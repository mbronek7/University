/* Michał Bronikowski, 292227 */
#include "traceroute.h"

struct timeval send_time[MAX_TTL_SIZE + 1], delivered_time[MAX_TTL_SIZE + 1];

struct sockaddr_in sender;
socklen_t sender_len = sizeof(sender);
char sender_ip_str[20];
u_int8_t buffer[IP_MAXPACKET];

void compute_delivered_time_data(struct timeval *timeTemp, int current_turn);
void check_delivered_status(const char *sender_ip_str, int current_turn);

int packages_count[MAX_TTL_SIZE + 1];

u_int16_t compute_icmp_checksum(const void *buff, int length)
{
    u_int32_t sum;
    const u_int16_t *ptr = (const u_int16_t *)buff;
    assert(length % 2 == 0);
    for (sum = 0; length > 0; length -= 2)
        sum += *ptr++;
    sum = (sum >> 16) + (sum & 0xffff);
    return (u_int16_t)(~(sum + (sum >> 16)));
}

int handle_package(int socket_FD, struct timeval timeTemp, char *dst, int package_number, int ready_descriptors, int ttl, int pid)
{
    if (ready_descriptors == 0)
    {
        printf("*");
        return MAX_ICMP_PACKAGES_COUNT;
    }
    else if (ready_descriptors == -1)
    {
        printf("error\n");
        return 0;
    }
    else
    {
        ssize_t received_package_status = recvfrom(socket_FD, buffer, IP_MAXPACKET, 0, (struct sockaddr *)&sender, &sender_len);
        if (received_package_status < 0)
        {
            fprintf(stderr, "error in recvfrom: %s\n", strerror(errno));
            return EXIT_FAILURE;
        }
        inet_ntop(AF_INET, &(sender.sin_addr), sender_ip_str, sizeof(sender_ip_str));
        struct iphdr *ip_header = (struct iphdr *)buffer;
        u_int8_t *ip_header_size = buffer + 4 * ip_header->ihl;
        struct icmphdr *icmphdr = (struct icmphdr *)(ip_header_size);
        if (!(icmphdr->type == ICMP_TIME_EXCEEDED))
        {
            if (icmphdr->type == ICMP_ECHOREPLY && icmphdr->un.echo.id == pid)
            {
                int current_turn = icmphdr->un.echo.sequence;
                if (current_turn < ttl)
                    return 0;
                check_delivered_status(sender_ip_str, current_turn);
                compute_delivered_time_data(&timeTemp, current_turn);
                if (strcmp(sender_ip_str, dst) == 0 && package_number == 2)
                {
                    return PACKAGE_DELIVERED;
                }
            }
            else
                return 1;
        }
        else
        {
            struct iphdr *ip_header = (struct iphdr *)(ip_header_size + 8);
            u_int8_t *ip_header_size_dat = ip_header_size + 8 + 4 * ip_header->ihl;
            struct icmphdr *icmphdr = (struct icmphdr *)ip_header_size_dat;
            if (!(pid != icmphdr->un.echo.id))
            {
                int current_turn = icmphdr->un.echo.sequence;
                if (current_turn < ttl)
                    return 0;
                else
                {
                    check_delivered_status(sender_ip_str, current_turn);
                    compute_delivered_time_data(&timeTemp, current_turn);
                    if (!strcmp(sender_ip_str, dst))
                        return PACKAGE_DELIVERED;
                }
            }
            else
            {
                return 1;
            }
        }
        return 0;
    }
}

void check_delivered_status(const char *sender_ip_str, int current_turn) {
    if (delivered_time[current_turn].tv_sec == 0 && delivered_time[current_turn].tv_usec == 0)
        printf("%-20s ", sender_ip_str);
}

void compute_delivered_time_data(struct timeval *timeTemp, int current_turn) {
    delivered_time[current_turn].tv_sec += (*timeTemp).tv_sec;
    delivered_time[current_turn].tv_usec += (*timeTemp).tv_usec;
    packages_count[current_turn]++;
}

ssize_t send_package(int socket_FD, struct sockaddr_in target, int ttl, int pid)
{
    struct icmphdr icmp_header;
    icmp_header.type = ICMP_ECHO;
    icmp_header.code = 0;
    icmp_header.un.echo.id = pid;
    icmp_header.un.echo.sequence = ttl;
    icmp_header.checksum = 0;
    icmp_header.checksum = compute_icmp_checksum((u_int16_t *)&icmp_header, sizeof(icmp_header));

    return sendto(socket_FD, &icmp_header, sizeof(icmp_header), 0, (struct sockaddr *)&target, sizeof(target));
}
