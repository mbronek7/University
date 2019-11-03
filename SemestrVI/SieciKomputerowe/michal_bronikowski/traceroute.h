/* Michał Bronikowski, 292227 */
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
#include <limits.h>

#define MAX_TTL_SIZE 30
#define MAX_ICMP_PACKAGES_COUNT 3
#define PACKAGE_DELIVERED INT_MIN
#define TIME_CONVERTING_CONSTANT 1000.0

typedef int bool;
#define true 1
#define false 0

u_int16_t compute_icmp_checksum(const void *buff, int length);
ssize_t send_package(int socket_FD, struct sockaddr_in target, int ttl, int pid);
int handle_package(int socket_FD, struct timeval timeTemp, char *dst, int package_number, int ready_descriptors, int ttl, int pid);
