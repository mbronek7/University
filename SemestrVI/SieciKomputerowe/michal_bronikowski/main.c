/* Michał Bronikowski, 292227 */
#include "traceroute.h"

extern int packages_count[MAX_TTL_SIZE + 1];
extern struct timeval send_time[MAX_TTL_SIZE + 1], delivered_time[MAX_TTL_SIZE + 1];

fd_set descriptors;
int ready_descriptors;
bool stop;
struct timeval restricted_timeout;
struct timeval current_time;

void check_if_finished(int delivered_status, bool *stop, int *i);
void init_data(int socket_FD, int *current_ttl_number, fd_set *descriptors, bool *stop, struct timeval *restricted_timeout);
void init_tables_with_time_and_packages_count(int i);
void print_average_time(int current_ttl_number);
void compute_send_time(int current_ttl_number, struct timeval *current_time);

int main(int argc, char **argv)
{
    struct sockaddr_in target;
    bzero(&target, sizeof(target));
    target.sin_family = AF_INET;

    int socket_FD = socket(AF_INET, SOCK_RAW, IPPROTO_ICMP);

    if (socket_FD < 0)
    {
        fprintf(stderr, "You need root privileges to use this program.\n");
        return EXIT_FAILURE;
    }

    if (argc != 2)
    {
        fprintf(stderr, "Missing host operand\n");
        return EXIT_FAILURE;
    }

    if (!inet_pton(AF_INET, argv[1], &target.sin_addr))
    {
        fprintf(stderr, "Incorrect host address\n");
        return EXIT_FAILURE;
    }

    for (int i = 0; i < MAX_TTL_SIZE; ++i)
    {
        init_tables_with_time_and_packages_count(i);
    }

    for (int current_ttl_number = 1; current_ttl_number <= MAX_TTL_SIZE; ++current_ttl_number)
    {
        init_data(socket_FD, &current_ttl_number, &descriptors, &stop, &restricted_timeout);

        for (int i = 0; i < MAX_ICMP_PACKAGES_COUNT; ++i)
        {
            ssize_t bytes_sent = send_package(socket_FD, target, current_ttl_number, getpid());
            compute_send_time(current_ttl_number, &current_time);
            if (bytes_sent >= 0)
                continue;
            printf("Failure the package has not been sent. Probably due to connection problems.\n");
            return EXIT_FAILURE;
        }

        printf("%2d.   ", current_ttl_number);

        for (int i = 0; i < MAX_ICMP_PACKAGES_COUNT; ++i)
        {
            ready_descriptors = select(socket_FD + 1, &descriptors, NULL, NULL, &restricted_timeout);
            gettimeofday(&current_time, NULL);
            int delivered_status = handle_package(socket_FD, current_time, argv[1], i, ready_descriptors, current_ttl_number, getpid());
            check_if_finished(delivered_status, &stop, &i);
        }

        if (packages_count[current_ttl_number] == MAX_ICMP_PACKAGES_COUNT)
        {
            print_average_time(current_ttl_number);
        }
        else if (packages_count[current_ttl_number] != 0)
            printf("???");

        printf("\n");
        if (stop)
            break;
    }

    return EXIT_SUCCESS;
}

void compute_send_time(int current_ttl_number, struct timeval *current_time)
{
    gettimeofday(current_time, NULL);
    send_time[current_ttl_number].tv_sec += (*current_time).tv_sec;
    send_time[current_ttl_number].tv_usec += (*current_time).tv_usec;
}

void print_average_time(int current_ttl_number)
{
    double time_difference_in_sec_to_ms =
        (delivered_time[current_ttl_number].tv_sec - send_time[current_ttl_number].tv_sec) *
        TIME_CONVERTING_CONSTANT;
    double time_difference_in_microsec_to_ms =
        (delivered_time[current_ttl_number].tv_usec - send_time[current_ttl_number].tv_usec) /
        TIME_CONVERTING_CONSTANT;
    double avg_time = (time_difference_in_sec_to_ms + time_difference_in_microsec_to_ms) / MAX_ICMP_PACKAGES_COUNT;
    printf("%-12f ms", avg_time);
}

void init_tables_with_time_and_packages_count(int i)
{
    packages_count[i] = 0;
    delivered_time[i].tv_sec = delivered_time[i].tv_usec = 0;
    send_time[i].tv_sec = send_time[i].tv_usec = 0;
}

void init_data(int socket_FD, int *current_ttl_number, fd_set *descriptors, bool *stop, struct timeval *restricted_timeout)
{
    (*stop) = false;
    setsockopt(socket_FD, IPPROTO_IP, IP_TTL, current_ttl_number, sizeof(int));
    FD_ZERO(descriptors);
    FD_SET(socket_FD, descriptors);
    (*restricted_timeout).tv_sec = 1;
    (*restricted_timeout).tv_usec = 0;
}

void check_if_finished(int delivered_status, bool *stop, int *i)
{
    if (delivered_status != PACKAGE_DELIVERED)
        (*i) += delivered_status;
    else
        (*stop) = true;
}
