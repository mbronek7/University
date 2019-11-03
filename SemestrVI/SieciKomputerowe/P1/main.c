
#include "traceroute.h"

extern struct timeval timeStart[MAX_TTL + 1], timeEnd[MAX_TTL + 1];
extern int packages_count[MAX_TTL + 1];

int main(int argc, char **argv)
{

    //inicjowanie tablic
    for (int i = 0; i < MAX_TTL; ++i)
    {
        timeStart[i].tv_sec = timeStart[i].tv_usec = 0;
        timeEnd[i].tv_sec = timeEnd[i].tv_usec = 0;
        packages_count[i] = 0;
    }
    //kod z wykładu
    struct sockaddr_in recipient;
    bzero(&recipient, sizeof(recipient));
    recipient.sin_family = AF_INET;

    int sockfd = socket(AF_INET, SOCK_RAW, IPPROTO_ICMP);

    //obsługa poprawności inicjalizacji, i zmiennych startowych
    if (sockfd < 0)
    {
        fprintf(stderr, "You need root privileges to use this program.\n");
        return EXIT_FAILURE;
    }

    if (argc != 2)
    {
        fprintf(stderr, "Missing host operand\n");
        return EXIT_FAILURE;
    }

    if (!inet_pton(AF_INET, argv[1], &recipient.sin_addr))
    {
        fprintf(stderr, "Incorrect host address\n");
        return EXIT_FAILURE;
    }

    //ttl \in [1,30]
    for (int ttl = 1; ttl <= 30; ++ttl)
    {
        setsockopt(sockfd, IPPROTO_IP, IP_TTL, &ttl, sizeof(int));
        for (int i = 0; i < 3; ++i)
        {

            struct timeval timeTemp;

            ssize_t bytes_sent = send_package(sockfd, ttl, recipient, getpid());
            gettimeofday(&timeTemp, NULL);

            timeStart[ttl].tv_sec += timeTemp.tv_sec;
            timeStart[ttl].tv_usec += timeTemp.tv_usec;
            if (bytes_sent < 0)
            {
                printf("Failure the package has not been sent.\n");
                return EXIT_FAILURE;
            }
        }

        fd_set descriptors;
        FD_ZERO(&descriptors);
        FD_SET(sockfd, &descriptors);
        //tv - czas oczekiwan, timeTemp - czas który zostanie dopasowany zgodnie z ttl pakietu
        struct timeval tv, timeTemp;
        tv.tv_sec = 1;
        tv.tv_usec = 0;

        int ready;
        bool wyjscie = false;
        printf("%2d   ", ttl);

        //odbieranie odpowiedzi
        for (int i = 0; i < 3; ++i)
        {
            ready = select(sockfd + 1, &descriptors, NULL, NULL, &tv);

            gettimeofday(&timeTemp, NULL);
            int delta = handle_package(sockfd, ttl, ready, timeTemp, argv[1], i, getpid());

            //delta = 10 - specjalny komunikat kontaktu z docelowym komputerem
            if (delta != 10)
                i += delta;
            else
                wyjscie = true;
        }
        //wyświetlenie średnich czasów
        if (packages_count[ttl] == 3){
            double temp = ((timeEnd[ttl].tv_sec - timeStart[ttl].tv_sec) * 1000.0 + (timeEnd[ttl].tv_usec - timeStart[ttl].tv_usec) / 1000.0) / 3;
            printf("%f ms", temp);
        }
        else if (packages_count[ttl] != 0)
            printf("???");

        printf("\n");
        if (wyjscie)
            break;
    }

    return EXIT_SUCCESS;
}
