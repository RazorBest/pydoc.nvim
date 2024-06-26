Python 3.10.14
*socket.pyx*                                  Last change: 2024 May 24

"socket" — Low-level networking interface
*****************************************

**Source code:** Lib/socket.py

======================================================================

This module provides access to the BSD _socket_ interface. It is
available on all modern Unix systems, Windows, MacOS, and probably
additional platforms.

Note:

  Some behavior may be platform dependent, since calls are made to the
  operating system socket APIs.

The Python interface is a straightforward transliteration of the Unix
system call and library interface for sockets to Python’s object-
oriented style: the "socket()" function returns a _socket object_
whose methods implement the various socket system calls.  Parameter
types are somewhat higher-level than in the C interface: as with
"read()" and "write()" operations on Python files, buffer allocation
on receive operations is automatic, and buffer length is implicit on
send operations.

See also:

  Module "socketserver"
     Classes that simplify writing network servers.

  Module "ssl"
     A TLS/SSL wrapper for socket objects.


Socket families
===============

Depending on the system and the build options, various socket families
are supported by this module.

The address format required by a particular socket object is
automatically selected based on the address family specified when the
socket object was created.  Socket addresses are represented as
follows:

* The address of an "AF_UNIX" socket bound to a file system node is
  represented as a string, using the file system encoding and the
  "'surrogateescape'" error handler (see **PEP 383**).  An address in
  Linux’s abstract namespace is returned as a _bytes-like object_ with
  an initial null byte; note that sockets in this namespace can
  communicate with normal file system sockets, so programs intended to
  run on Linux may need to deal with both types of address.  A string
  or bytes-like object can be used for either type of address when
  passing it as an argument.

  Changed in version 3.3: Previously, "AF_UNIX" socket paths were
  assumed to use UTF-8 encoding.

  Changed in version 3.5: Writable _bytes-like object_ is now
  accepted.

* A pair "(host, port)" is used for the "AF_INET" address family,
  where _host_ is a string representing either a hostname in internet
  domain notation like "'daring.cwi.nl'" or an IPv4 address like
  "'100.50.200.5'", and _port_ is an integer.

  * For IPv4 addresses, two special forms are accepted instead of a
    host address: "''" represents "INADDR_ANY", which is used to bind
    to all interfaces, and the string "'<broadcast>'" represents
    "INADDR_BROADCAST".  This behavior is not compatible with IPv6,
    therefore, you may want to avoid these if you intend to support
    IPv6 with your Python programs.

* For "AF_INET6" address family, a four-tuple "(host, port, flowinfo,
  scope_id)" is used, where _flowinfo_ and _scope_id_ represent the
  "sin6_flowinfo" and "sin6_scope_id" members in "struct sockaddr_in6"
  in C.  For "socket" module methods, _flowinfo_ and _scope_id_ can be
  omitted just for backward compatibility.  Note, however, omission of
  _scope_id_ can cause problems in manipulating scoped IPv6 addresses.

  Changed in version 3.7: For multicast addresses (with _scope_id_
  meaningful) _address_ may not contain "%scope_id" (or "zone id")
  part. This information is superfluous and may be safely omitted
  (recommended).

* "AF_NETLINK" sockets are represented as pairs "(pid, groups)".

* Linux-only support for TIPC is available using the "AF_TIPC" address
  family.  TIPC is an open, non-IP based networked protocol designed
  for use in clustered computer environments.  Addresses are
  represented by a tuple, and the fields depend on the address type.
  The general tuple form is "(addr_type, v1, v2, v3 [, scope])",
  where:

  * _addr_type_ is one of "TIPC_ADDR_NAMESEQ", "TIPC_ADDR_NAME", or
    "TIPC_ADDR_ID".

  * _scope_ is one of "TIPC_ZONE_SCOPE", "TIPC_CLUSTER_SCOPE", and
    "TIPC_NODE_SCOPE".

  * If _addr_type_ is "TIPC_ADDR_NAME", then _v1_ is the server type,
    _v2_ is the port identifier, and _v3_ should be 0.

    If _addr_type_ is "TIPC_ADDR_NAMESEQ", then _v1_ is the server
    type, _v2_ is the lower port number, and _v3_ is the upper port
    number.

    If _addr_type_ is "TIPC_ADDR_ID", then _v1_ is the node, _v2_ is
    the reference, and _v3_ should be set to 0.

* A tuple "(interface, )" is used for the "AF_CAN" address family,
  where _interface_ is a string representing a network interface name
  like "'can0'". The network interface name "''" can be used to
  receive packets from all network interfaces of this family.

  * "CAN_ISOTP" protocol require a tuple "(interface, rx_addr,
    tx_addr)" where both additional parameters are unsigned long
    integer that represent a CAN identifier (standard or extended).

  * "CAN_J1939" protocol require a tuple "(interface, name, pgn,
    addr)" where additional parameters are 64-bit unsigned integer
    representing the ECU name, a 32-bit unsigned integer representing
    the Parameter Group Number (PGN), and an 8-bit integer
    representing the address.

* A string or a tuple "(id, unit)" is used for the "SYSPROTO_CONTROL"
  protocol of the "PF_SYSTEM" family. The string is the name of a
  kernel control using a dynamically assigned ID. The tuple can be
  used if ID and unit number of the kernel control are known or if a
  registered ID is used.

  New in version 3.3.

* "AF_BLUETOOTH" supports the following protocols and address formats:

  * "BTPROTO_L2CAP" accepts "(bdaddr, psm)" where "bdaddr" is the
    Bluetooth address as a string and "psm" is an integer.

  * "BTPROTO_RFCOMM" accepts "(bdaddr, channel)" where "bdaddr" is the
    Bluetooth address as a string and "channel" is an integer.

  * "BTPROTO_HCI" accepts "(device_id,)" where "device_id" is either
    an integer or a string with the Bluetooth address of the
    interface. (This depends on your OS; NetBSD and DragonFlyBSD
    expect a Bluetooth address while everything else expects an
    integer.)

    Changed in version 3.2: NetBSD and DragonFlyBSD support added.

  * "BTPROTO_SCO" accepts "bdaddr" where "bdaddr" is a "bytes" object
    containing the Bluetooth address in a string format. (ex.
    "b'12:23:34:45:56:67'") This protocol is not supported under
    FreeBSD.

* "AF_ALG" is a Linux-only socket based interface to Kernel
  cryptography. An algorithm socket is configured with a tuple of two
  to four elements "(type, name [, feat [, mask]])", where:

  * _type_ is the algorithm type as string, e.g. "aead", "hash",
    "skcipher" or "rng".

  * _name_ is the algorithm name and operation mode as string, e.g.
    "sha256", "hmac(sha256)", "cbc(aes)" or "drbg_nopr_ctr_aes256".

  * _feat_ and _mask_ are unsigned 32bit integers.

  Availability: Linux 2.6.38, some algorithm types require more recent
  Kernels.

  New in version 3.6.

* "AF_VSOCK" allows communication between virtual machines and their
  hosts. The sockets are represented as a "(CID, port)" tuple where
  the context ID or CID and port are integers.

  Availability: Linux >= 4.8 QEMU >= 2.8 ESX >= 4.0 ESX Workstation >=
  6.5.

  New in version 3.7.

* "AF_PACKET" is a low-level interface directly to network devices.
  The packets are represented by the tuple "(ifname, proto[, pkttype[,
  hatype[, addr]]])" where:

  * _ifname_ - String specifying the device name.

  * _proto_ - An in network-byte-order integer specifying the Ethernet
    protocol number.

  * _pkttype_ - Optional integer specifying the packet type:

    * "PACKET_HOST" (the default) - Packet addressed to the local
      host.

    * "PACKET_BROADCAST" - Physical-layer broadcast packet.

    * "PACKET_MULTIHOST" - Packet sent to a physical-layer multicast
      address.

    * "PACKET_OTHERHOST" - Packet to some other host that has been
      caught by a device driver in promiscuous mode.

    * "PACKET_OUTGOING" - Packet originating from the local host that
      is looped back to a packet socket.

  * _hatype_ - Optional integer specifying the ARP hardware address
    type.

  * _addr_ - Optional bytes-like object specifying the hardware
    physical address, whose interpretation depends on the device.

     Availability: Linux >= 2.2.

* "AF_QIPCRTR" is a Linux-only socket based interface for
  communicating with services running on co-processors in Qualcomm
  platforms. The address family is represented as a "(node, port)"
  tuple where the _node_ and _port_ are non-negative integers.

     Availability: Linux >= 4.7.

  New in version 3.8.

* "IPPROTO_UDPLITE" is a variant of UDP which allows you to specify
  what portion of a packet is covered with the checksum. It adds two
  socket options that you can change.
  "self.setsockopt(IPPROTO_UDPLITE, UDPLITE_SEND_CSCOV, length)" will
  change what portion of outgoing packets are covered by the checksum
  and "self.setsockopt(IPPROTO_UDPLITE, UDPLITE_RECV_CSCOV, length)"
  will filter out packets which cover too little of their data. In
  both cases "length" should be in "range(8, 2**16, 8)".

  Such a socket should be constructed with "socket(AF_INET,
  SOCK_DGRAM, IPPROTO_UDPLITE)" for IPv4 or "socket(AF_INET6,
  SOCK_DGRAM, IPPROTO_UDPLITE)" for IPv6.

  Availability: Linux >= 2.6.20, FreeBSD >= 10.1-RELEASE

  New in version 3.9.

If you use a hostname in the _host_ portion of IPv4/v6 socket address,
the program may show a nondeterministic behavior, as Python uses the
first address returned from the DNS resolution.  The socket address
will be resolved differently into an actual IPv4/v6 address, depending
on the results from DNS resolution and/or the host configuration.  For
deterministic behavior use a numeric address in _host_ portion.

All errors raise exceptions.  The normal exceptions for invalid
argument types and out-of-memory conditions can be raised. Errors
related to socket or address semantics raise "OSError" or one of its
subclasses.

Non-blocking mode is supported through "setblocking()".  A
generalization of this based on timeouts is supported through
"settimeout()".


Module contents
===============

The module "socket" exports the following elements.


Exceptions
----------

exception socket.error

   A deprecated alias of "OSError".

   Changed in version 3.3: Following **PEP 3151**, this class was made
   an alias of "OSError".

exception socket.herror

   A subclass of "OSError", this exception is raised for address-
   related errors, i.e. for functions that use _h_errno_ in the POSIX
   C API, including "gethostbyname_ex()" and "gethostbyaddr()". The
   accompanying value is a pair "(h_errno, string)" representing an
   error returned by a library call.  _h_errno_ is a numeric value,
   while _string_ represents the description of _h_errno_, as returned
   by the "hstrerror()" C function.

   Changed in version 3.3: This class was made a subclass of
   "OSError".

exception socket.gaierror

   A subclass of "OSError", this exception is raised for address-
   related errors by "getaddrinfo()" and "getnameinfo()". The
   accompanying value is a pair "(error, string)" representing an
   error returned by a library call.  _string_ represents the
   description of _error_, as returned by the "gai_strerror()" C
   function.  The numeric _error_ value will match one of the "EAI_*"
   constants defined in this module.

   Changed in version 3.3: This class was made a subclass of
   "OSError".

exception socket.timeout

   A deprecated alias of "TimeoutError".

   A subclass of "OSError", this exception is raised when a timeout
   occurs on a socket which has had timeouts enabled via a prior call
   to "settimeout()" (or implicitly through "setdefaulttimeout()").
   The accompanying value is a string whose value is currently always
   “timed out”.

   Changed in version 3.3: This class was made a subclass of
   "OSError".

   Changed in version 3.10: This class was made an alias of
   "TimeoutError".


Constants
---------

   The AF_* and SOCK_* constants are now "AddressFamily" and
   "SocketKind" "IntEnum" collections.

   New in version 3.4.

socket.AF_UNIX
socket.AF_INET
socket.AF_INET6

   These constants represent the address (and protocol) families, used
   for the first argument to "socket()".  If the "AF_UNIX" constant is
   not defined then this protocol is unsupported.  More constants may
   be available depending on the system.

socket.SOCK_STREAM
socket.SOCK_DGRAM
socket.SOCK_RAW
socket.SOCK_RDM
socket.SOCK_SEQPACKET

   These constants represent the socket types, used for the second
   argument to "socket()".  More constants may be available depending
   on the system. (Only "SOCK_STREAM" and "SOCK_DGRAM" appear to be
   generally useful.)

socket.SOCK_CLOEXEC
socket.SOCK_NONBLOCK

   These two constants, if defined, can be combined with the socket
   types and allow you to set some flags atomically (thus avoiding
   possible race conditions and the need for separate calls).

   See also:

     Secure File Descriptor Handling for a more thorough explanation.

   Availability: Linux >= 2.6.27.

   New in version 3.2.

SO_*
socket.SOMAXCONN
MSG_*
SOL_*
SCM_*
IPPROTO_*
IPPORT_*
INADDR_*
IP_*
IPV6_*
EAI_*
AI_*
NI_*
TCP_*

   Many constants of these forms, documented in the Unix documentation
   on sockets and/or the IP protocol, are also defined in the socket
   module. They are generally used in arguments to the "setsockopt()"
   and "getsockopt()" methods of socket objects.  In most cases, only
   those symbols that are defined in the Unix header files are
   defined; for a few symbols, default values are provided.

   Changed in version 3.6: "SO_DOMAIN", "SO_PROTOCOL", "SO_PEERSEC",
   "SO_PASSSEC", "TCP_USER_TIMEOUT", "TCP_CONGESTION" were added.

   Changed in version 3.6.5: On Windows, "TCP_FASTOPEN", "TCP_KEEPCNT"
   appear if run-time Windows supports.

   Changed in version 3.7: "TCP_NOTSENT_LOWAT" was added.On Windows,
   "TCP_KEEPIDLE", "TCP_KEEPINTVL" appear if run-time Windows
   supports.

   Changed in version 3.10: "IP_RECVTOS" was added.  Added
   "TCP_KEEPALIVE". On MacOS this constant can be used in the same
   way that "TCP_KEEPIDLE" is used on Linux.

socket.AF_CAN
socket.PF_CAN
SOL_CAN_*
CAN_*

   Many constants of these forms, documented in the Linux
   documentation, are also defined in the socket module.

   Availability: Linux >= 2.6.25.

   New in version 3.3.

socket.CAN_BCM
CAN_BCM_*

   CAN_BCM, in the CAN protocol family, is the broadcast manager (BCM)
   protocol. Broadcast manager constants, documented in the Linux
   documentation, are also defined in the socket module.

   Availability: Linux >= 2.6.25.

   Note:

     The "CAN_BCM_CAN_FD_FRAME" flag is only available on Linux >=
     4.8.

   New in version 3.4.

socket.CAN_RAW_FD_FRAMES

   Enables CAN FD support in a CAN_RAW socket. This is disabled by
   default. This allows your application to send both CAN and CAN FD
   frames; however, you must accept both CAN and CAN FD frames when
   reading from the socket.

   This constant is documented in the Linux documentation.

   Availability: Linux >= 3.6.

   New in version 3.5.

socket.CAN_RAW_JOIN_FILTERS

   Joins the applied CAN filters such that only CAN frames that match
   all given CAN filters are passed to user space.

   This constant is documented in the Linux documentation.

   Availability: Linux >= 4.1.

   New in version 3.9.

socket.CAN_ISOTP

   CAN_ISOTP, in the CAN protocol family, is the ISO-TP (ISO 15765-2)
   protocol. ISO-TP constants, documented in the Linux documentation.

   Availability: Linux >= 2.6.25.

   New in version 3.7.

socket.CAN_J1939

   CAN_J1939, in the CAN protocol family, is the SAE J1939 protocol.
   J1939 constants, documented in the Linux documentation.

   Availability: Linux >= 5.4.

   New in version 3.9.

socket.AF_PACKET
socket.PF_PACKET
PACKET_*

   Many constants of these forms, documented in the Linux
   documentation, are also defined in the socket module.

   Availability: Linux >= 2.2.

socket.AF_RDS
socket.PF_RDS
socket.SOL_RDS
RDS_*

   Many constants of these forms, documented in the Linux
   documentation, are also defined in the socket module.

   Availability: Linux >= 2.6.30.

   New in version 3.3.

socket.SIO_RCVALL
socket.SIO_KEEPALIVE_VALS
socket.SIO_LOOPBACK_FAST_PATH
RCVALL_*

   Constants for Windows’ WSAIoctl(). The constants are used as
   arguments to the "ioctl()" method of socket objects.

   Changed in version 3.6: "SIO_LOOPBACK_FAST_PATH" was added.

TIPC_*

   TIPC related constants, matching the ones exported by the C socket
   API. See the TIPC documentation for more information.

socket.AF_ALG
socket.SOL_ALG
ALG_*

   Constants for Linux Kernel cryptography.

   Availability: Linux >= 2.6.38.

   New in version 3.6.

socket.AF_VSOCK
socket.IOCTL_VM_SOCKETS_GET_LOCAL_CID
VMADDR*
SO_VM*

   Constants for Linux host/guest communication.

   Availability: Linux >= 4.8.

   New in version 3.7.

socket.AF_LINK

   Availability: BSD, macOS.

   New in version 3.4.

socket.has_ipv6

   This constant contains a boolean value which indicates if IPv6 is
   supported on this platform.

socket.BDADDR_ANY
socket.BDADDR_LOCAL

   These are string constants containing Bluetooth addresses with
   special meanings. For example, "BDADDR_ANY" can be used to indicate
   any address when specifying the binding socket with
   "BTPROTO_RFCOMM".

socket.HCI_FILTER
socket.HCI_TIME_STAMP
socket.HCI_DATA_DIR

   For use with "BTPROTO_HCI". "HCI_FILTER" is not available for
   NetBSD or DragonFlyBSD. "HCI_TIME_STAMP" and "HCI_DATA_DIR" are not
   available for FreeBSD, NetBSD, or DragonFlyBSD.

socket.AF_QIPCRTR

   Constant for Qualcomm’s IPC router protocol, used to communicate
   with service providing remote processors.

   Availability: Linux >= 4.7.


Functions
---------


Creating sockets
~~~~~~~~~~~~~~~~

The following functions all create socket objects.

class socket.socket(family=AF_INET, type=SOCK_STREAM, proto=0, fileno=None)

   Create a new socket using the given address family, socket type and
   protocol number.  The address family should be "AF_INET" (the
   default), "AF_INET6", "AF_UNIX", "AF_CAN", "AF_PACKET", or
   "AF_RDS". The socket type should be "SOCK_STREAM" (the default),
   "SOCK_DGRAM", "SOCK_RAW" or perhaps one of the other "SOCK_"
   constants. The protocol number is usually zero and may be omitted
   or in the case where the address family is "AF_CAN" the protocol
   should be one of "CAN_RAW", "CAN_BCM", "CAN_ISOTP" or "CAN_J1939".

   If _fileno_ is specified, the values for _family_, _type_, and
   _proto_ are auto-detected from the specified file descriptor.
   Auto-detection can be overruled by calling the function with
   explicit _family_, _type_, or _proto_ arguments.  This only affects
   how Python represents e.g. the return value of
   "socket.getpeername()" but not the actual OS resource.  Unlike
   "socket.fromfd()", _fileno_ will return the same socket and not a
   duplicate. This may help close a detached socket using
   "socket.close()".

   The newly created socket is non-inheritable.

   Raises an auditing event "socket.__new__" with arguments "self",
   "family", "type", "protocol".

   Changed in version 3.3: The AF_CAN family was added. The AF_RDS
   family was added.

   Changed in version 3.4: The CAN_BCM protocol was added.

   Changed in version 3.4: The returned socket is now non-inheritable.

   Changed in version 3.7: The CAN_ISOTP protocol was added.

   Changed in version 3.7: When "SOCK_NONBLOCK" or "SOCK_CLOEXEC" bit
   flags are applied to _type_ they are cleared, and "socket.type"
   will not reflect them.  They are still passed to the underlying
   system "socket()" call.  Therefore,

>
      sock = socket.socket(
          socket.AF_INET,
          socket.SOCK_STREAM | socket.SOCK_NONBLOCK)
<
   will still create a non-blocking socket on OSes that support
   "SOCK_NONBLOCK", but "sock.type" will be set to
   "socket.SOCK_STREAM".

   Changed in version 3.9: The CAN_J1939 protocol was added.

   Changed in version 3.10: The IPPROTO_MPTCP protocol was added.

socket.socketpair([family[, type[, proto]]])

   Build a pair of connected socket objects using the given address
   family, socket type, and protocol number.  Address family, socket
   type, and protocol number are as for the "socket()" function above.
   The default family is "AF_UNIX" if defined on the platform;
   otherwise, the default is "AF_INET".

   The newly created sockets are non-inheritable.

   Changed in version 3.2: The returned socket objects now support the
   whole socket API, rather than a subset.

   Changed in version 3.4: The returned sockets are now non-
   inheritable.

   Changed in version 3.5: Windows support added.

socket.create_connection(address[, timeout[, source_address]])

   Connect to a TCP service listening on the internet _address_ (a
   2-tuple "(host, port)"), and return the socket object.  This is a
   higher-level function than "socket.connect()": if _host_ is a non-
   numeric hostname, it will try to resolve it for both "AF_INET" and
   "AF_INET6", and then try to connect to all possible addresses in
   turn until a connection succeeds.  This makes it easy to write
   clients that are compatible to both IPv4 and IPv6.

   Passing the optional _timeout_ parameter will set the timeout on
   the socket instance before attempting to connect.  If no _timeout_
   is supplied, the global default timeout setting returned by
   "getdefaulttimeout()" is used.

   If supplied, _source_address_ must be a 2-tuple "(host, port)" for
   the socket to bind to as its source address before connecting.  If
   host or port are ‘’ or 0 respectively the OS default behavior will
   be used.

   Changed in version 3.2: _source_address_ was added.

socket.create_server(address, *, family=AF_INET, backlog=None, reuse_port=False, dualstack_ipv6=False)

   Convenience function which creates a TCP socket bound to _address_
   (a 2-tuple "(host, port)") and return the socket object.

   _family_ should be either "AF_INET" or "AF_INET6". _backlog_ is the
   queue size passed to "socket.listen()"; if not specified , a
   default reasonable value is chosen. _reuse_port_ dictates whether
   to set the "SO_REUSEPORT" socket option.

   If _dualstack_ipv6_ is true and the platform supports it the socket
   will be able to accept both IPv4 and IPv6 connections, else it will
   raise "ValueError". Most POSIX platforms and Windows are supposed
   to support this functionality. When this functionality is enabled
   the address returned by "socket.getpeername()" when an IPv4
   connection occurs will be an IPv6 address represented as an
   IPv4-mapped IPv6 address. If _dualstack_ipv6_ is false it will
   explicitly disable this functionality on platforms that enable it
   by default (e.g. Linux). This parameter can be used in conjunction
   with "has_dualstack_ipv6()":
>
      import socket

      addr = ("", 8080)  # all interfaces, port 8080
      if socket.has_dualstack_ipv6():
          s = socket.create_server(addr, family=socket.AF_INET6, dualstack_ipv6=True)
      else:
          s = socket.create_server(addr)
<
   Note:

     On POSIX platforms the "SO_REUSEADDR" socket option is set in
     order to immediately reuse previous sockets which were bound on
     the same _address_ and remained in TIME_WAIT state.

   New in version 3.8.

socket.has_dualstack_ipv6()

   Return "True" if the platform supports creating a TCP socket which
   can handle both IPv4 and IPv6 connections.

   New in version 3.8.

socket.fromfd(fd, family, type, proto=0)

   Duplicate the file descriptor _fd_ (an integer as returned by a
   file object’s "fileno()" method) and build a socket object from the
   result.  Address family, socket type and protocol number are as for
   the "socket()" function above. The file descriptor should refer to
   a socket, but this is not checked — subsequent operations on the
   object may fail if the file descriptor is invalid. This function is
   rarely needed, but can be used to get or set socket options on a
   socket passed to a program as standard input or output (such as a
   server started by the Unix inet daemon).  The socket is assumed to
   be in blocking mode.

   The newly created socket is non-inheritable.

   Changed in version 3.4: The returned socket is now non-inheritable.

socket.fromshare(data)

   Instantiate a socket from data obtained from the "socket.share()"
   method.  The socket is assumed to be in blocking mode.

   Availability: Windows.

   New in version 3.3.

socket.SocketType

   This is a Python type object that represents the socket object
   type. It is the same as "type(socket(...))".


Other functions
~~~~~~~~~~~~~~~

The "socket" module also offers various network-related services:

socket.close(fd)

   Close a socket file descriptor. This is like "os.close()", but for
   sockets. On some platforms (most noticeable Windows) "os.close()"
   does not work for socket file descriptors.

   New in version 3.7.

socket.getaddrinfo(host, port, family=0, type=0, proto=0, flags=0)

   Translate the _host_/_port_ argument into a sequence of 5-tuples
   that contain all the necessary arguments for creating a socket
   connected to that service. _host_ is a domain name, a string
   representation of an IPv4/v6 address or "None". _port_ is a string
   service name such as "'http'", a numeric port number or "None".  By
   passing "None" as the value of _host_ and _port_, you can pass
   "NULL" to the underlying C API.

   The _family_, _type_ and _proto_ arguments can be optionally
   specified in order to narrow the list of addresses returned.
   Passing zero as a value for each of these arguments selects the
   full range of results. The _flags_ argument can be one or several
   of the "AI_*" constants, and will influence how results are
   computed and returned. For example, "AI_NUMERICHOST" will disable
   domain name resolution and will raise an error if _host_ is a
   domain name.

   The function returns a list of 5-tuples with the following
   structure:

   "(family, type, proto, canonname, sockaddr)"

   In these tuples, _family_, _type_, _proto_ are all integers and are
   meant to be passed to the "socket()" function.  _canonname_ will be
   a string representing the canonical name of the _host_ if
   "AI_CANONNAME" is part of the _flags_ argument; else _canonname_
   will be empty.  _sockaddr_ is a tuple describing a socket address,
   whose format depends on the returned _family_ (a "(address, port)"
   2-tuple for "AF_INET", a "(address, port, flowinfo, scope_id)"
   4-tuple for "AF_INET6"), and is meant to be passed to the
   "socket.connect()" method.

   Raises an auditing event "socket.getaddrinfo" with arguments
   "host", "port", "family", "type", "protocol".

   The following example fetches address information for a
   hypothetical TCP connection to "example.org" on port 80 (results
   may differ on your system if IPv6 isn’t enabled):
>
      >>> socket.getaddrinfo("example.org", 80, proto=socket.IPPROTO_TCP)
      [(<AddressFamily.AF_INET6: 10>, <AddressFamily.SOCK_STREAM: 1>,
       6, '', ('2606:2800:220:1:248:1893:25c8:1946', 80, 0, 0)),
       (<AddressFamily.AF_INET: 2>, <AddressFamily.SOCK_STREAM: 1>,
       6, '', ('93.184.216.34', 80))]
<
   Changed in version 3.2: parameters can now be passed using keyword
   arguments.

   Changed in version 3.7: for IPv6 multicast addresses, string
   representing an address will not contain "%scope_id" part.

socket.getfqdn([name])

   Return a fully qualified domain name for _name_. If _name_ is
   omitted or empty, it is interpreted as the local host.  To find the
   fully qualified name, the hostname returned by "gethostbyaddr()" is
   checked, followed by aliases for the host, if available.  The first
   name which includes a period is selected.  In case no fully
   qualified domain name is available and _name_ was provided, it is
   returned unchanged.  If _name_ was empty or equal to "'0.0.0.0'",
   the hostname from "gethostname()" is returned.

socket.gethostbyname(hostname)

   Translate a host name to IPv4 address format.  The IPv4 address is
   returned as a string, such as  "'100.50.200.5'".  If the host name
   is an IPv4 address itself it is returned unchanged.  See
   "gethostbyname_ex()" for a more complete interface.
   "gethostbyname()" does not support IPv6 name resolution, and
   "getaddrinfo()" should be used instead for IPv4/v6 dual stack
   support.

   Raises an auditing event "socket.gethostbyname" with argument
   "hostname".

socket.gethostbyname_ex(hostname)

   Translate a host name to IPv4 address format, extended interface.
   Return a triple "(hostname, aliaslist, ipaddrlist)" where
   _hostname_ is the host’s primary host name, _aliaslist_ is a
   (possibly empty) list of alternative host names for the same
   address, and _ipaddrlist_ is a list of IPv4 addresses for the same
   interface on the same host (often but not always a single address).
   "gethostbyname_ex()" does not support IPv6 name resolution, and
   "getaddrinfo()" should be used instead for IPv4/v6 dual stack
   support.

   Raises an auditing event "socket.gethostbyname" with argument
   "hostname".

socket.gethostname()

   Return a string containing the hostname of the machine where  the
   Python interpreter is currently executing.

   Raises an auditing event "socket.gethostname" with no arguments.

   Note: "gethostname()" doesn’t always return the fully qualified
   domain name; use "getfqdn()" for that.

socket.gethostbyaddr(ip_address)

   Return a triple "(hostname, aliaslist, ipaddrlist)" where
   _hostname_ is the primary host name responding to the given
   _ip_address_, _aliaslist_ is a (possibly empty) list of alternative
   host names for the same address, and _ipaddrlist_ is a list of
   IPv4/v6 addresses for the same interface on the same host (most
   likely containing only a single address). To find the fully
   qualified domain name, use the function "getfqdn()".
   "gethostbyaddr()" supports both IPv4 and IPv6.

   Raises an auditing event "socket.gethostbyaddr" with argument
   "ip_address".

socket.getnameinfo(sockaddr, flags)

   Translate a socket address _sockaddr_ into a 2-tuple "(host,
   port)". Depending on the settings of _flags_, the result can
   contain a fully qualified domain name or numeric address
   representation in _host_.  Similarly, _port_ can contain a string
   port name or a numeric port number.

   For IPv6 addresses, "%scope_id" is appended to the host part if
   _sockaddr_ contains meaningful _scope_id_. Usually this happens for
   multicast addresses.

   For more information about _flags_ you can consult
   _getnameinfo(3)_.

   Raises an auditing event "socket.getnameinfo" with argument
   "sockaddr".

socket.getprotobyname(protocolname)

   Translate an internet protocol name (for example, "'icmp'") to a
   constant suitable for passing as the (optional) third argument to
   the "socket()" function.  This is usually only needed for sockets
   opened in “raw” mode ("SOCK_RAW"); for the normal socket modes, the
   correct protocol is chosen automatically if the protocol is omitted
   or zero.

socket.getservbyname(servicename[, protocolname])

   Translate an internet service name and protocol name to a port
   number for that service.  The optional protocol name, if given,
   should be "'tcp'" or "'udp'", otherwise any protocol will match.

   Raises an auditing event "socket.getservbyname" with arguments
   "servicename", "protocolname".

socket.getservbyport(port[, protocolname])

   Translate an internet port number and protocol name to a service
   name for that service.  The optional protocol name, if given,
   should be "'tcp'" or "'udp'", otherwise any protocol will match.

   Raises an auditing event "socket.getservbyport" with arguments
   "port", "protocolname".

socket.ntohl(x)

   Convert 32-bit positive integers from network to host byte order.
   On machines where the host byte order is the same as network byte
   order, this is a no-op; otherwise, it performs a 4-byte swap
   operation.

socket.ntohs(x)

   Convert 16-bit positive integers from network to host byte order.
   On machines where the host byte order is the same as network byte
   order, this is a no-op; otherwise, it performs a 2-byte swap
   operation.

   Changed in version 3.10: Raises "OverflowError" if _x_ does not fit
   in a 16-bit unsigned integer.

socket.htonl(x)

   Convert 32-bit positive integers from host to network byte order.
   On machines where the host byte order is the same as network byte
   order, this is a no-op; otherwise, it performs a 4-byte swap
   operation.

socket.htons(x)

   Convert 16-bit positive integers from host to network byte order.
   On machines where the host byte order is the same as network byte
   order, this is a no-op; otherwise, it performs a 2-byte swap
   operation.

   Changed in version 3.10: Raises "OverflowError" if _x_ does not fit
   in a 16-bit unsigned integer.

socket.inet_aton(ip_string)

   Convert an IPv4 address from dotted-quad string format (for
   example, ‘123.45.67.89’) to 32-bit packed binary format, as a bytes
   object four characters in length.  This is useful when conversing
   with a program that uses the standard C library and needs objects
   of type "in_addr", which is the C type for the 32-bit packed binary
   this function returns.

   "inet_aton()" also accepts strings with less than three dots; see
   the Unix manual page _inet(3)_ for details.

   If the IPv4 address string passed to this function is invalid,
   "OSError" will be raised. Note that exactly what is valid depends
   on the underlying C implementation of "inet_aton()".

   "inet_aton()" does not support IPv6, and "inet_pton()" should be
   used instead for IPv4/v6 dual stack support.

socket.inet_ntoa(packed_ip)

   Convert a 32-bit packed IPv4 address (a _bytes-like object_ four
   bytes in length) to its standard dotted-quad string representation
   (for example, ‘123.45.67.89’).  This is useful when conversing with
   a program that uses the standard C library and needs objects of
   type "in_addr", which is the C type for the 32-bit packed binary
   data this function takes as an argument.

   If the byte sequence passed to this function is not exactly 4 bytes
   in length, "OSError" will be raised. "inet_ntoa()" does not support
   IPv6, and "inet_ntop()" should be used instead for IPv4/v6 dual
   stack support.

   Changed in version 3.5: Writable _bytes-like object_ is now
   accepted.

socket.inet_pton(address_family, ip_string)

   Convert an IP address from its family-specific string format to a
   packed, binary format. "inet_pton()" is useful when a library or
   network protocol calls for an object of type "in_addr" (similar to
   "inet_aton()") or "in6_addr".

   Supported values for _address_family_ are currently "AF_INET" and
   "AF_INET6". If the IP address string _ip_string_ is invalid,
   "OSError" will be raised. Note that exactly what is valid depends
   on both the value of _address_family_ and the underlying
   implementation of "inet_pton()".

   Availability: Unix (maybe not all platforms), Windows.

   Changed in version 3.4: Windows support added

socket.inet_ntop(address_family, packed_ip)

   Convert a packed IP address (a _bytes-like object_ of some number
   of bytes) to its standard, family-specific string representation
   (for example, "'7.10.0.5'" or "'5aef:2b::8'"). "inet_ntop()" is
   useful when a library or network protocol returns an object of type
   "in_addr" (similar to "inet_ntoa()") or "in6_addr".

   Supported values for _address_family_ are currently "AF_INET" and
   "AF_INET6". If the bytes object _packed_ip_ is not the correct
   length for the specified address family, "ValueError" will be
   raised. "OSError" is raised for errors from the call to
   "inet_ntop()".

   Availability: Unix (maybe not all platforms), Windows.

   Changed in version 3.4: Windows support added

   Changed in version 3.5: Writable _bytes-like object_ is now
   accepted.

socket.CMSG_LEN(length)

   Return the total length, without trailing padding, of an ancillary
   data item with associated data of the given _length_.  This value
   can often be used as the buffer size for "recvmsg()" to receive a
   single item of ancillary data, but **RFC 3542** requires portable
   applications to use "CMSG_SPACE()" and thus include space for
   padding, even when the item will be the last in the buffer.  Raises
   "OverflowError" if _length_ is outside the permissible range of
   values.

   Availability: most Unix platforms, possibly others.

   New in version 3.3.

socket.CMSG_SPACE(length)

   Return the buffer size needed for "recvmsg()" to receive an
   ancillary data item with associated data of the given _length_,
   along with any trailing padding.  The buffer space needed to
   receive multiple items is the sum of the "CMSG_SPACE()" values for
   their associated data lengths.  Raises "OverflowError" if _length_
   is outside the permissible range of values.

   Note that some systems might support ancillary data without
   providing this function.  Also note that setting the buffer size
   using the results of this function may not precisely limit the
   amount of ancillary data that can be received, since additional
   data may be able to fit into the padding area.

   Availability: most Unix platforms, possibly others.

   New in version 3.3.

socket.getdefaulttimeout()

   Return the default timeout in seconds (float) for new socket
   objects. A value of "None" indicates that new socket objects have
   no timeout. When the socket module is first imported, the default
   is "None".

socket.setdefaulttimeout(timeout)

   Set the default timeout in seconds (float) for new socket objects.
   When the socket module is first imported, the default is "None".
   See "settimeout()" for possible values and their respective
   meanings.

socket.sethostname(name)

   Set the machine’s hostname to _name_.  This will raise an "OSError"
   if you don’t have enough rights.

   Raises an auditing event "socket.sethostname" with argument "name".

   Availability: Unix.

   New in version 3.3.

socket.if_nameindex()

   Return a list of network interface information (index int, name
   string) tuples. "OSError" if the system call fails.

   Availability: Unix, Windows.

   New in version 3.3.

   Changed in version 3.8: Windows support was added.

   Note:

     On Windows network interfaces have different names in different
     contexts (all names are examples):

     * UUID: "{FB605B73-AAC2-49A6-9A2F-25416AEA0573}"

     * name: "ethernet_32770"

     * friendly name: "vEthernet (nat)"

     * description: "Hyper-V Virtual Ethernet Adapter"

     This function returns names of the second form from the list,
     "ethernet_32770" in this example case.

socket.if_nametoindex(if_name)

   Return a network interface index number corresponding to an
   interface name. "OSError" if no interface with the given name
   exists.

   Availability: Unix, Windows.

   New in version 3.3.

   Changed in version 3.8: Windows support was added.

   See also:

     “Interface name” is a name as documented in "if_nameindex()".

socket.if_indextoname(if_index)

   Return a network interface name corresponding to an interface index
   number. "OSError" if no interface with the given index exists.

   Availability: Unix, Windows.

   New in version 3.3.

   Changed in version 3.8: Windows support was added.

   See also:

     “Interface name” is a name as documented in "if_nameindex()".

socket.send_fds(sock, buffers, fds[, flags[, address]])

   Send the list of file descriptors _fds_ over an "AF_UNIX" socket
   _sock_. The _fds_ parameter is a sequence of file descriptors.
   Consult "sendmsg()" for the documentation of these parameters.

   Availability: Unix supporting "sendmsg()" and "SCM_RIGHTS"
   mechanism.

   New in version 3.9.

socket.recv_fds(sock, bufsize, maxfds[, flags])

   Receive up to _maxfds_ file descriptors from an "AF_UNIX" socket
   _sock_. Return "(msg, list(fds), flags, addr)". Consult "recvmsg()"
   for the documentation of these parameters.

   Availability: Unix supporting "recvmsg()" and "SCM_RIGHTS"
   mechanism.

   New in version 3.9.

   Note:

     Any truncated integers at the end of the list of file
     descriptors.


Socket Objects
==============

Socket objects have the following methods.  Except for "makefile()",
these correspond to Unix system calls applicable to sockets.

Changed in version 3.2: Support for the _context manager_ protocol was
added.  Exiting the context manager is equivalent to calling
"close()".

socket.accept()

   Accept a connection. The socket must be bound to an address and
   listening for connections. The return value is a pair "(conn,
   address)" where _conn_ is a _new_ socket object usable to send and
   receive data on the connection, and _address_ is the address bound
   to the socket on the other end of the connection.

   The newly created socket is non-inheritable.

   Changed in version 3.4: The socket is now non-inheritable.

   Changed in version 3.5: If the system call is interrupted and the
   signal handler does not raise an exception, the method now retries
   the system call instead of raising an "InterruptedError" exception
   (see **PEP 475** for the rationale).

socket.bind(address)

   Bind the socket to _address_.  The socket must not already be
   bound. (The format of _address_ depends on the address family — see
   above.)

   Raises an auditing event "socket.bind" with arguments "self",
   "address".

socket.close()

   Mark the socket closed.  The underlying system resource (e.g. a
   file descriptor) is also closed when all file objects from
   "makefile()" are closed.  Once that happens, all future operations
   on the socket object will fail. The remote end will receive no more
   data (after queued data is flushed).

   Sockets are automatically closed when they are garbage-collected,
   but it is recommended to "close()" them explicitly, or to use a
   "with" statement around them.

   Changed in version 3.6: "OSError" is now raised if an error occurs
   when the underlying "close()" call is made.

   Note:

     "close()" releases the resource associated with a connection but
     does not necessarily close the connection immediately.  If you
     want to close the connection in a timely fashion, call
     "shutdown()" before "close()".

socket.connect(address)

   Connect to a remote socket at _address_. (The format of _address_
   depends on the address family — see above.)

   If the connection is interrupted by a signal, the method waits
   until the connection completes, or raise a "TimeoutError" on
   timeout, if the signal handler doesn’t raise an exception and the
   socket is blocking or has a timeout. For non-blocking sockets, the
   method raises an "InterruptedError" exception if the connection is
   interrupted by a signal (or the exception raised by the signal
   handler).

   Raises an auditing event "socket.connect" with arguments "self",
   "address".

   Changed in version 3.5: The method now waits until the connection
   completes instead of raising an "InterruptedError" exception if the
   connection is interrupted by a signal, the signal handler doesn’t
   raise an exception and the socket is blocking or has a timeout (see
   the **PEP 475** for the rationale).

socket.connect_ex(address)

   Like "connect(address)", but return an error indicator instead of
   raising an exception for errors returned by the C-level "connect()"
   call (other problems, such as “host not found,” can still raise
   exceptions).  The error indicator is "0" if the operation
   succeeded, otherwise the value of the "errno" variable.  This is
   useful to support, for example, asynchronous connects.

   Raises an auditing event "socket.connect" with arguments "self",
   "address".

socket.detach()

   Put the socket object into closed state without actually closing
   the underlying file descriptor.  The file descriptor is returned,
   and can be reused for other purposes.

   New in version 3.2.

socket.dup()

   Duplicate the socket.

   The newly created socket is non-inheritable.

   Changed in version 3.4: The socket is now non-inheritable.

socket.fileno()

   Return the socket’s file descriptor (a small integer), or -1 on
   failure. This is useful with "select.select()".

   Under Windows the small integer returned by this method cannot be
   used where a file descriptor can be used (such as "os.fdopen()").
   Unix does not have this limitation.

socket.get_inheritable()

   Get the inheritable flag of the socket’s file descriptor or
   socket’s handle: "True" if the socket can be inherited in child
   processes, "False" if it cannot.

   New in version 3.4.

socket.getpeername()

   Return the remote address to which the socket is connected.  This
   is useful to find out the port number of a remote IPv4/v6 socket,
   for instance. (The format of the address returned depends on the
   address family — see above.)  On some systems this function is not
   supported.

socket.getsockname()

   Return the socket’s own address.  This is useful to find out the
   port number of an IPv4/v6 socket, for instance. (The format of the
   address returned depends on the address family — see above.)

socket.getsockopt(level, optname[, buflen])

   Return the value of the given socket option (see the Unix man page
   _getsockopt(2)_).  The needed symbolic constants ("SO_*" etc.) are
   defined in this module.  If _buflen_ is absent, an integer option
   is assumed and its integer value is returned by the function.  If
   _buflen_ is present, it specifies the maximum length of the buffer
   used to receive the option in, and this buffer is returned as a
   bytes object.  It is up to the caller to decode the contents of the
   buffer (see the optional built-in module "struct" for a way to
   decode C structures encoded as byte strings).

socket.getblocking()

   Return "True" if socket is in blocking mode, "False" if in non-
   blocking.

   This is equivalent to checking "socket.gettimeout() == 0".

   New in version 3.7.

socket.gettimeout()

   Return the timeout in seconds (float) associated with socket
   operations, or "None" if no timeout is set.  This reflects the last
   call to "setblocking()" or "settimeout()".

socket.ioctl(control, option)

   Platform:
      Windows

   The "ioctl()" method is a limited interface to the WSAIoctl system
   interface.  Please refer to the Win32 documentation for more
   information.

   On other platforms, the generic "fcntl.fcntl()" and "fcntl.ioctl()"
   functions may be used; they accept a socket object as their first
   argument.

   Currently only the following control codes are supported:
   "SIO_RCVALL", "SIO_KEEPALIVE_VALS", and "SIO_LOOPBACK_FAST_PATH".

   Changed in version 3.6: "SIO_LOOPBACK_FAST_PATH" was added.

socket.listen([backlog])

   Enable a server to accept connections.  If _backlog_ is specified,
   it must be at least 0 (if it is lower, it is set to 0); it
   specifies the number of unaccepted connections that the system will
   allow before refusing new connections. If not specified, a default
   reasonable value is chosen.

   Changed in version 3.5: The _backlog_ parameter is now optional.

socket.makefile(mode='r', buffering=None, *, encoding=None, errors=None, newline=None)

   Return a _file object_ associated with the socket.  The exact
   returned type depends on the arguments given to "makefile()".
   These arguments are interpreted the same way as by the built-in
   "open()" function, except the only supported _mode_ values are
   "'r'" (default), "'w'" and "'b'".

   The socket must be in blocking mode; it can have a timeout, but the
   file object’s internal buffer may end up in an inconsistent state
   if a timeout occurs.

   Closing the file object returned by "makefile()" won’t close the
   original socket unless all other file objects have been closed and
   "socket.close()" has been called on the socket object.

   Note:

     On Windows, the file-like object created by "makefile()" cannot
     be used where a file object with a file descriptor is expected,
     such as the stream arguments of "subprocess.Popen()".

socket.recv(bufsize[, flags])

   Receive data from the socket.  The return value is a bytes object
   representing the data received.  The maximum amount of data to be
   received at once is specified by _bufsize_.  See the Unix manual
   page _recv(2)_ for the meaning of the optional argument _flags_; it
   defaults to zero.

   Note:

     For best match with hardware and network realities, the value of
     _bufsize_ should be a relatively small power of 2, for example,
     4096.

   Changed in version 3.5: If the system call is interrupted and the
   signal handler does not raise an exception, the method now retries
   the system call instead of raising an "InterruptedError" exception
   (see **PEP 475** for the rationale).

socket.recvfrom(bufsize[, flags])

   Receive data from the socket.  The return value is a pair "(bytes,
   address)" where _bytes_ is a bytes object representing the data
   received and _address_ is the address of the socket sending the
   data.  See the Unix manual page _recv(2)_ for the meaning of the
   optional argument _flags_; it defaults to zero. (The format of
   _address_ depends on the address family — see above.)

   Changed in version 3.5: If the system call is interrupted and the
   signal handler does not raise an exception, the method now retries
   the system call instead of raising an "InterruptedError" exception
   (see **PEP 475** for the rationale).

   Changed in version 3.7: For multicast IPv6 address, first item of
   _address_ does not contain "%scope_id" part anymore. In order to
   get full IPv6 address use "getnameinfo()".

socket.recvmsg(bufsize[, ancbufsize[, flags]])

   Receive normal data (up to _bufsize_ bytes) and ancillary data from
   the socket.  The _ancbufsize_ argument sets the size in bytes of
   the internal buffer used to receive the ancillary data; it defaults
   to 0, meaning that no ancillary data will be received.  Appropriate
   buffer sizes for ancillary data can be calculated using
   "CMSG_SPACE()" or "CMSG_LEN()", and items which do not fit into the
   buffer might be truncated or discarded.  The _flags_ argument
   defaults to 0 and has the same meaning as for "recv()".

   The return value is a 4-tuple: "(data, ancdata, msg_flags,
   address)".  The _data_ item is a "bytes" object holding the non-
   ancillary data received.  The _ancdata_ item is a list of zero or
   more tuples "(cmsg_level, cmsg_type, cmsg_data)" representing the
   ancillary data (control messages) received: _cmsg_level_ and
   _cmsg_type_ are integers specifying the protocol level and
   protocol-specific type respectively, and _cmsg_data_ is a "bytes"
   object holding the associated data.  The _msg_flags_ item is the
   bitwise OR of various flags indicating conditions on the received
   message; see your system documentation for details. If the
   receiving socket is unconnected, _address_ is the address of the
   sending socket, if available; otherwise, its value is unspecified.

   On some systems, "sendmsg()" and "recvmsg()" can be used to pass
   file descriptors between processes over an "AF_UNIX" socket.  When
   this facility is used (it is often restricted to "SOCK_STREAM"
   sockets), "recvmsg()" will return, in its ancillary data, items of
   the form "(socket.SOL_SOCKET, socket.SCM_RIGHTS, fds)", where _fds_
   is a "bytes" object representing the new file descriptors as a
   binary array of the native C "int" type.  If "recvmsg()" raises an
   exception after the system call returns, it will first attempt to
   close any file descriptors received via this mechanism.

   Some systems do not indicate the truncated length of ancillary data
   items which have been only partially received.  If an item appears
   to extend beyond the end of the buffer, "recvmsg()" will issue a
   "RuntimeWarning", and will return the part of it which is inside
   the buffer provided it has not been truncated before the start of
   its associated data.

   On systems which support the "SCM_RIGHTS" mechanism, the following
   function will receive up to _maxfds_ file descriptors, returning
   the message data and a list containing the descriptors (while
   ignoring unexpected conditions such as unrelated control messages
   being received).  See also "sendmsg()".
>
      import socket, array

      def recv_fds(sock, msglen, maxfds):
          fds = array.array("i")   # Array of ints
          msg, ancdata, flags, addr = sock.recvmsg(msglen, socket.CMSG_LEN(maxfds * fds.itemsize))
          for cmsg_level, cmsg_type, cmsg_data in ancdata:
              if cmsg_level == socket.SOL_SOCKET and cmsg_type == socket.SCM_RIGHTS:
                  # Append data, ignoring any truncated integers at the end.
                  fds.frombytes(cmsg_data[:len(cmsg_data) - (len(cmsg_data) % fds.itemsize)])
          return msg, list(fds)
<
   Availability: most Unix platforms, possibly others.

   New in version 3.3.

   Changed in version 3.5: If the system call is interrupted and the
   signal handler does not raise an exception, the method now retries
   the system call instead of raising an "InterruptedError" exception
   (see **PEP 475** for the rationale).

socket.recvmsg_into(buffers[, ancbufsize[, flags]])

   Receive normal data and ancillary data from the socket, behaving as
   "recvmsg()" would, but scatter the non-ancillary data into a series
   of buffers instead of returning a new bytes object.  The _buffers_
   argument must be an iterable of objects that export writable
   buffers (e.g. "bytearray" objects); these will be filled with
   successive chunks of the non-ancillary data until it has all been
   written or there are no more buffers.  The operating system may set
   a limit ("sysconf()" value "SC_IOV_MAX") on the number of buffers
   that can be used.  The _ancbufsize_ and _flags_ arguments have the
   same meaning as for "recvmsg()".

   The return value is a 4-tuple: "(nbytes, ancdata, msg_flags,
   address)", where _nbytes_ is the total number of bytes of non-
   ancillary data written into the buffers, and _ancdata_, _msg_flags_
   and _address_ are the same as for "recvmsg()".

   Example:
>
      >>> import socket
      >>> s1, s2 = socket.socketpair()
      >>> b1 = bytearray(b'----')
      >>> b2 = bytearray(b'0123456789')
      >>> b3 = bytearray(b'--------------')
      >>> s1.send(b'Mary had a little lamb')
      22
      >>> s2.recvmsg_into([b1, memoryview(b2)[2:9], b3])
      (22, [], 0, None)
      >>> [b1, b2, b3]
      [bytearray(b'Mary'), bytearray(b'01 had a 9'), bytearray(b'little lamb---')]
<
   Availability: most Unix platforms, possibly others.

   New in version 3.3.

socket.recvfrom_into(buffer[, nbytes[, flags]])

   Receive data from the socket, writing it into _buffer_ instead of
   creating a new bytestring.  The return value is a pair "(nbytes,
   address)" where _nbytes_ is the number of bytes received and
   _address_ is the address of the socket sending the data.  See the
   Unix manual page _recv(2)_ for the meaning of the optional argument
   _flags_; it defaults to zero.  (The format of _address_ depends on
   the address family — see above.)

socket.recv_into(buffer[, nbytes[, flags]])

   Receive up to _nbytes_ bytes from the socket, storing the data into
   a buffer rather than creating a new bytestring.  If _nbytes_ is not
   specified (or 0), receive up to the size available in the given
   buffer.  Returns the number of bytes received.  See the Unix manual
   page _recv(2)_ for the meaning of the optional argument _flags_; it
   defaults to zero.

socket.send(bytes[, flags])

   Send data to the socket.  The socket must be connected to a remote
   socket.  The optional _flags_ argument has the same meaning as for
   "recv()" above. Returns the number of bytes sent. Applications are
   responsible for checking that all data has been sent; if only some
   of the data was transmitted, the application needs to attempt
   delivery of the remaining data. For further information on this
   topic, consult the Socket Programming HOWTO.

   Changed in version 3.5: If the system call is interrupted and the
   signal handler does not raise an exception, the method now retries
   the system call instead of raising an "InterruptedError" exception
   (see **PEP 475** for the rationale).

socket.sendall(bytes[, flags])

   Send data to the socket.  The socket must be connected to a remote
   socket.  The optional _flags_ argument has the same meaning as for
   "recv()" above. Unlike "send()", this method continues to send data
   from _bytes_ until either all data has been sent or an error
   occurs.  "None" is returned on success.  On error, an exception is
   raised, and there is no way to determine how much data, if any, was
   successfully sent.

   Changed in version 3.5: The socket timeout is no longer reset each
   time data is sent successfully. The socket timeout is now the
   maximum total duration to send all data.

   Changed in version 3.5: If the system call is interrupted and the
   signal handler does not raise an exception, the method now retries
   the system call instead of raising an "InterruptedError" exception
   (see **PEP 475** for the rationale).

socket.sendto(bytes, address)
socket.sendto(bytes, flags, address)

   Send data to the socket.  The socket should not be connected to a
   remote socket, since the destination socket is specified by
   _address_.  The optional _flags_ argument has the same meaning as
   for "recv()" above.  Return the number of bytes sent. (The format
   of _address_ depends on the address family — see above.)

   Raises an auditing event "socket.sendto" with arguments "self",
   "address".

   Changed in version 3.5: If the system call is interrupted and the
   signal handler does not raise an exception, the method now retries
   the system call instead of raising an "InterruptedError" exception
   (see **PEP 475** for the rationale).

socket.sendmsg(buffers[, ancdata[, flags[, address]]])

   Send normal and ancillary data to the socket, gathering the non-
   ancillary data from a series of buffers and concatenating it into a
   single message.  The _buffers_ argument specifies the non-ancillary
   data as an iterable of _bytes-like objects_ (e.g. "bytes" objects);
   the operating system may set a limit ("sysconf()" value
   "SC_IOV_MAX") on the number of buffers that can be used.  The
   _ancdata_ argument specifies the ancillary data (control messages)
   as an iterable of zero or more tuples "(cmsg_level, cmsg_type,
   cmsg_data)", where _cmsg_level_ and _cmsg_type_ are integers
   specifying the protocol level and protocol-specific type
   respectively, and _cmsg_data_ is a bytes-like object holding the
   associated data.  Note that some systems (in particular, systems
   without "CMSG_SPACE()") might support sending only one control
   message per call.  The _flags_ argument defaults to 0 and has the
   same meaning as for "send()".  If _address_ is supplied and not
   "None", it sets a destination address for the message.  The return
   value is the number of bytes of non-ancillary data sent.

   The following function sends the list of file descriptors _fds_
   over an "AF_UNIX" socket, on systems which support the "SCM_RIGHTS"
   mechanism.  See also "recvmsg()".
>
      import socket, array

      def send_fds(sock, msg, fds):
          return sock.sendmsg([msg], [(socket.SOL_SOCKET, socket.SCM_RIGHTS, array.array("i", fds))])
<
   Availability: most Unix platforms, possibly others.

   Raises an auditing event "socket.sendmsg" with arguments "self",
   "address".

   New in version 3.3.

   Changed in version 3.5: If the system call is interrupted and the
   signal handler does not raise an exception, the method now retries
   the system call instead of raising an "InterruptedError" exception
   (see **PEP 475** for the rationale).

socket.sendmsg_afalg([msg], *, op[, iv[, assoclen[, flags]]])

   Specialized version of "sendmsg()" for "AF_ALG" socket. Set mode,
   IV, AEAD associated data length and flags for "AF_ALG" socket.

   Availability: Linux >= 2.6.38.

   New in version 3.6.

socket.sendfile(file, offset=0, count=None)

   Send a file until EOF is reached by using high-performance
   "os.sendfile" and return the total number of bytes which were sent.
   _file_ must be a regular file object opened in binary mode. If
   "os.sendfile" is not available (e.g. Windows) or _file_ is not a
   regular file "send()" will be used instead. _offset_ tells from
   where to start reading the file. If specified, _count_ is the total
   number of bytes to transmit as opposed to sending the file until
   EOF is reached. File position is updated on return or also in case
   of error in which case "file.tell()" can be used to figure out the
   number of bytes which were sent. The socket must be of
   "SOCK_STREAM" type. Non-blocking sockets are not supported.

   New in version 3.5.

socket.set_inheritable(inheritable)

   Set the inheritable flag of the socket’s file descriptor or
   socket’s handle.

   New in version 3.4.

socket.setblocking(flag)

   Set blocking or non-blocking mode of the socket: if _flag_ is
   false, the socket is set to non-blocking, else to blocking mode.

   This method is a shorthand for certain "settimeout()" calls:

   * "sock.setblocking(True)" is equivalent to "sock.settimeout(None)"

   * "sock.setblocking(False)" is equivalent to "sock.settimeout(0.0)"

   Changed in version 3.7: The method no longer applies
   "SOCK_NONBLOCK" flag on "socket.type".

socket.settimeout(value)

   Set a timeout on blocking socket operations.  The _value_ argument
   can be a nonnegative floating point number expressing seconds, or
   "None". If a non-zero value is given, subsequent socket operations
   will raise a "timeout" exception if the timeout period _value_ has
   elapsed before the operation has completed.  If zero is given, the
   socket is put in non-blocking mode. If "None" is given, the socket
   is put in blocking mode.

   For further information, please consult the notes on socket
   timeouts.

   Changed in version 3.7: The method no longer toggles
   "SOCK_NONBLOCK" flag on "socket.type".

socket.setsockopt(level, optname, value: int)

socket.setsockopt(level, optname, value: buffer)

socket.setsockopt(level, optname, None, optlen: int)

   Set the value of the given socket option (see the Unix manual page
   _setsockopt(2)_).  The needed symbolic constants are defined in the
   "socket" module ("SO_*" etc.).  The value can be an integer, "None"
   or a _bytes-like object_ representing a buffer. In the later case
   it is up to the caller to ensure that the bytestring contains the
   proper bits (see the optional built-in module "struct" for a way to
   encode C structures as bytestrings). When _value_ is set to "None",
   _optlen_ argument is required. It’s equivalent to call
   "setsockopt()" C function with "optval=NULL" and "optlen=optlen".

   Changed in version 3.5: Writable _bytes-like object_ is now
   accepted.

   Changed in version 3.6: setsockopt(level, optname, None, optlen:
   int) form added.

socket.shutdown(how)

   Shut down one or both halves of the connection.  If _how_ is
   "SHUT_RD", further receives are disallowed.  If _how_ is "SHUT_WR",
   further sends are disallowed.  If _how_ is "SHUT_RDWR", further
   sends and receives are disallowed.

socket.share(process_id)

   Duplicate a socket and prepare it for sharing with a target
   process.  The target process must be provided with _process_id_.
   The resulting bytes object can then be passed to the target process
   using some form of interprocess communication and the socket can be
   recreated there using "fromshare()". Once this method has been
   called, it is safe to close the socket since the operating system
   has already duplicated it for the target process.

   Availability: Windows.

   New in version 3.3.

Note that there are no methods "read()" or "write()"; use "recv()" and
"send()" without _flags_ argument instead.

Socket objects also have these (read-only) attributes that correspond
to the values given to the "socket" constructor.

socket.family

   The socket family.

socket.type

   The socket type.

socket.proto

   The socket protocol.


Notes on socket timeouts
========================

A socket object can be in one of three modes: blocking, non-blocking,
or timeout.  Sockets are by default always created in blocking mode,
but this can be changed by calling "setdefaulttimeout()".

* In _blocking mode_, operations block until complete or the system
  returns an error (such as connection timed out).

* In _non-blocking mode_, operations fail (with an error that is
  unfortunately system-dependent) if they cannot be completed
  immediately: functions from the "select" module can be used to know
  when and whether a socket is available for reading or writing.

* In _timeout mode_, operations fail if they cannot be completed
  within the timeout specified for the socket (they raise a "timeout"
  exception) or if the system returns an error.

Note:

  At the operating system level, sockets in _timeout mode_ are
  internally set in non-blocking mode.  Also, the blocking and timeout
  modes are shared between file descriptors and socket objects that
  refer to the same network endpoint. This implementation detail can
  have visible consequences if e.g. you decide to use the "fileno()"
  of a socket.


Timeouts and the "connect" method
---------------------------------

The "connect()" operation is also subject to the timeout setting, and
in general it is recommended to call "settimeout()" before calling
"connect()" or pass a timeout parameter to "create_connection()".
However, the system network stack may also return a connection timeout
error of its own regardless of any Python socket timeout setting.


Timeouts and the "accept" method
--------------------------------

If "getdefaulttimeout()" is not "None", sockets returned by the
"accept()" method inherit that timeout.  Otherwise, the behaviour
depends on settings of the listening socket:

* if the listening socket is in _blocking mode_ or in _timeout mode_,
  the socket returned by "accept()" is in _blocking mode_;

* if the listening socket is in _non-blocking mode_, whether the
  socket returned by "accept()" is in blocking or non-blocking mode is
  operating system-dependent.  If you want to ensure cross-platform
  behaviour, it is recommended you manually override this setting.


Example
=======

Here are four minimal example programs using the TCP/IP protocol: a
server that echoes all data that it receives back (servicing only one
client), and a client using it.  Note that a server must perform the
sequence "socket()", "bind()", "listen()", "accept()" (possibly
repeating the "accept()" to service more than one client), while a
client only needs the sequence "socket()", "connect()".  Also note
that the server does not "sendall()"/"recv()" on the socket it is
listening on but on the new socket returned by "accept()".

The first two examples support IPv4 only.
>
   # Echo server program
   import socket

   HOST = ''                 # Symbolic name meaning all available interfaces
   PORT = 50007              # Arbitrary non-privileged port
   with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
       s.bind((HOST, PORT))
       s.listen(1)
       conn, addr = s.accept()
       with conn:
           print('Connected by', addr)
           while True:
               data = conn.recv(1024)
               if not data: break
               conn.sendall(data)
<
>
   # Echo client program
   import socket

   HOST = 'daring.cwi.nl'    # The remote host
   PORT = 50007              # The same port as used by the server
   with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
       s.connect((HOST, PORT))
       s.sendall(b'Hello, world')
       data = s.recv(1024)
   print('Received', repr(data))
<
The next two examples are identical to the above two, but support both
IPv4 and IPv6. The server side will listen to the first address family
available (it should listen to both instead). On most of IPv6-ready
systems, IPv6 will take precedence and the server may not accept IPv4
traffic. The client side will try to connect to the all addresses
returned as a result of the name resolution, and sends traffic to the
first one connected successfully.
>
   # Echo server program
   import socket
   import sys

   HOST = None               # Symbolic name meaning all available interfaces
   PORT = 50007              # Arbitrary non-privileged port
   s = None
   for res in socket.getaddrinfo(HOST, PORT, socket.AF_UNSPEC,
                                 socket.SOCK_STREAM, 0, socket.AI_PASSIVE):
       af, socktype, proto, canonname, sa = res
       try:
           s = socket.socket(af, socktype, proto)
       except OSError as msg:
           s = None
           continue
       try:
           s.bind(sa)
           s.listen(1)
       except OSError as msg:
           s.close()
           s = None
           continue
       break
   if s is None:
       print('could not open socket')
       sys.exit(1)
   conn, addr = s.accept()
   with conn:
       print('Connected by', addr)
       while True:
           data = conn.recv(1024)
           if not data: break
           conn.send(data)
<
>
   # Echo client program
   import socket
   import sys

   HOST = 'daring.cwi.nl'    # The remote host
   PORT = 50007              # The same port as used by the server
   s = None
   for res in socket.getaddrinfo(HOST, PORT, socket.AF_UNSPEC, socket.SOCK_STREAM):
       af, socktype, proto, canonname, sa = res
       try:
           s = socket.socket(af, socktype, proto)
       except OSError as msg:
           s = None
           continue
       try:
           s.connect(sa)
       except OSError as msg:
           s.close()
           s = None
           continue
       break
   if s is None:
       print('could not open socket')
       sys.exit(1)
   with s:
       s.sendall(b'Hello, world')
       data = s.recv(1024)
   print('Received', repr(data))
<
The next example shows how to write a very simple network sniffer with
raw sockets on Windows. The example requires administrator privileges
to modify the interface:
>
   import socket

   # the public network interface
   HOST = socket.gethostbyname(socket.gethostname())

   # create a raw socket and bind it to the public interface
   s = socket.socket(socket.AF_INET, socket.SOCK_RAW, socket.IPPROTO_IP)
   s.bind((HOST, 0))

   # Include IP headers
   s.setsockopt(socket.IPPROTO_IP, socket.IP_HDRINCL, 1)

   # receive all packets
   s.ioctl(socket.SIO_RCVALL, socket.RCVALL_ON)

   # receive a packet
   print(s.recvfrom(65565))

   # disabled promiscuous mode
   s.ioctl(socket.SIO_RCVALL, socket.RCVALL_OFF)
<
The next example shows how to use the socket interface to communicate
to a CAN network using the raw socket protocol. To use CAN with the
broadcast manager protocol instead, open a socket with:
>
   socket.socket(socket.AF_CAN, socket.SOCK_DGRAM, socket.CAN_BCM)
<
After binding ("CAN_RAW") or connecting ("CAN_BCM") the socket, you
can use the "socket.send()" and "socket.recv()" operations (and their
counterparts) on the socket object as usual.

This last example might require special privileges:
>
   import socket
   import struct


   # CAN frame packing/unpacking (see 'struct can_frame' in <linux/can.h>)

   can_frame_fmt = "=IB3x8s"
   can_frame_size = struct.calcsize(can_frame_fmt)

   def build_can_frame(can_id, data):
       can_dlc = len(data)
       data = data.ljust(8, b'\x00')
       return struct.pack(can_frame_fmt, can_id, can_dlc, data)

   def dissect_can_frame(frame):
       can_id, can_dlc, data = struct.unpack(can_frame_fmt, frame)
       return (can_id, can_dlc, data[:can_dlc])


   # create a raw socket and bind it to the 'vcan0' interface
   s = socket.socket(socket.AF_CAN, socket.SOCK_RAW, socket.CAN_RAW)
   s.bind(('vcan0',))

   while True:
       cf, addr = s.recvfrom(can_frame_size)

       print('Received: can_id=%x, can_dlc=%x, data=%s' % dissect_can_frame(cf))

       try:
           s.send(cf)
       except OSError:
           print('Error sending CAN frame')

       try:
           s.send(build_can_frame(0x01, b'\x01\x02\x03'))
       except OSError:
           print('Error sending CAN frame')
<
Running an example several times with too small delay between
executions, could lead to this error:
>
   OSError: [Errno 98] Address already in use
<
This is because the previous execution has left the socket in a
"TIME_WAIT" state, and can’t be immediately reused.

There is a "socket" flag to set, in order to prevent this,
"socket.SO_REUSEADDR":
>
   s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
   s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
   s.bind((HOST, PORT))
<
the "SO_REUSEADDR" flag tells the kernel to reuse a local socket in
"TIME_WAIT" state, without waiting for its natural timeout to expire.

See also:

  For an introduction to socket programming (in C), see the following
  papers:

  * _An Introductory 4.3BSD Interprocess Communication Tutorial_, by
    Stuart Sechrest

  * _An Advanced 4.3BSD Interprocess Communication Tutorial_, by
    Samuel J.  Leffler et al,

  both in the UNIX Programmer’s Manual, Supplementary Documents 1
  (sections PS1:7 and PS1:8).  The platform-specific reference
  material for the various socket-related system calls are also a
  valuable source of information on the details of socket semantics.
  For Unix, refer to the manual pages; for Windows, see the WinSock
  (or Winsock 2) specification.  For IPv6-ready APIs, readers may want
  to refer to **RFC 3493** titled Basic Socket Interface Extensions
  for IPv6.

vim:tw=78:ts=8:ft=help:norl: