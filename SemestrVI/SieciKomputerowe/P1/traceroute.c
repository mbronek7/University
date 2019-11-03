
#include "traceroute.h"

struct timeval timeStart[MAX_TTL + 1], timeEnd[MAX_TTL + 1];
int packages_count[MAX_TTL + 1];

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

int handle_package(int sockfd, int ttl, int ready, struct timeval timeTemp, char *dst, int nrOdbioru, int pid)
{
    switch (ready)
    {
    case 0:
    {
        printf("* ");
        return 3; //niestety nie udało się odebrać pakietu na określonym ttl :(
        break;
    }
    case -1:
    {
        printf("nieznany błąd\n");
        break;
    }
    default:
    {

        struct sockaddr_in sender;
        socklen_t sender_len = sizeof(sender);
        u_int8_t buffer[IP_MAXPACKET];

        ssize_t packet_len = recvfrom(sockfd, buffer, IP_MAXPACKET, 0, (struct sockaddr *)&sender, &sender_len);
        if (packet_len < 0)
        {
            fprintf(stderr, "recvfrom error: %s\n", strerror(errno));
            return EXIT_FAILURE;
        }

        char sender_ip_str[20];

        inet_ntop(AF_INET, &(sender.sin_addr), sender_ip_str, sizeof(sender_ip_str));

        struct iphdr *ip_header = (struct iphdr *)buffer;
        u_int8_t *ip_header_len = buffer + 4 * ip_header->ihl;
        struct icmphdr *icmphdr = (struct icmphdr *)(ip_header_len);

        if (icmphdr->type == ICMP_TIME_EXCEEDED)
        {
            struct iphdr *ip_header = (struct iphdr *)(ip_header_len + 8);
            u_int8_t *ip_header_len_dat = ip_header_len + 8 + 4 * ip_header->ihl;
            struct icmphdr *icmphdr = (struct icmphdr *)ip_header_len_dat;

            if (pid != icmphdr->un.echo.id)
            {
                return -1;
            } //to nie mój pakiet
            int sq = icmphdr->un.echo.sequence;
            if (sq < ttl)
                break; //ignorowanie pakietów z mniejszym ttl

            if (timeEnd[sq].tv_sec == 0 && timeEnd[sq].tv_usec == 0)
                printf("%s ", sender_ip_str);

            timeEnd[sq].tv_sec += timeTemp.tv_sec;
            timeEnd[sq].tv_usec += timeTemp.tv_usec;

            packages_count[sq]++;
            if (!strcmp(sender_ip_str, dst))
                return 10;
        }
        else if (icmphdr->type == ICMP_ECHOREPLY && icmphdr->un.echo.id == pid)
        {
            int sq = icmphdr->un.echo.sequence;
            if (sq < ttl)
                break; //ignorowanie pakietów z mniejszym ttl

            if (timeEnd[sq].tv_sec == 0 && timeEnd[sq].tv_usec == 0)
                printf("%s ", sender_ip_str);

            timeEnd[sq].tv_sec += timeTemp.tv_sec;
            timeEnd[sq].tv_usec += timeTemp.tv_usec;

            packages_count[sq]++;

            if (strcmp(sender_ip_str, dst) == 0 && nrOdbioru == 2)
            {
                return 10; //specjalny komunikat
            }
        }
        else
            return -1; //to nie był mój komunikat

        break;
    }
    }
    return 0;
}

ssize_t send_package(int sockfd, int ttl, struct sockaddr_in recipient, int pid)
{
    struct icmphdr icmp_header;
    icmp_header.type = ICMP_ECHO;
    icmp_header.code = 0;
    icmp_header.un.echo.id = pid;
    icmp_header.un.echo.sequence = ttl;
    icmp_header.checksum = 0;
    icmp_header.checksum = compute_icmp_checksum((u_int16_t *)&icmp_header, sizeof(icmp_header));

    return sendto(
        sockfd,
        &icmp_header,
        sizeof(icmp_header),
        0,
        (struct sockaddr *)&recipient,
        sizeof(recipient));
}
