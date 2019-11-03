
#include <netinet/ip.h>
#include <netinet/ip_icmp.h>
#include <arpa/inet.h>
#include <stdio.h>
#include <stdlib.h>
#include <strings.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include <assert.h>
#include <sys/time.h>

#define MAX_TTL 30

typedef int bool;
#define true 1
#define false 0

u_int16_t compute_icmp_checksum(const void *buff, int length);
int handle_package(int sockfd, int ttl, int ready, struct timeval timeTemp, char *dst, int nrOdbioru, int pid);
ssize_t send_package(int sockfd, int ttl, struct sockaddr_in recipient, int pid);
