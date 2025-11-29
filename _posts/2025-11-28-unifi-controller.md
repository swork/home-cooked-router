---
title: Unifi Controller setup
---
I'd originally intended to run the Unifi controller software on the router, but
it turns out that gets complicated. MongoDB really likes its extended CPU
options, like AVX and SSE on Intel, and really particularly wants Intel chips or
emulations that supply these features.

So I dug into the aging Proxmox installation on an old Dell laptop that's been
spinning in the corner for a few years, running a database and a server neither
to much purpose, and brought up a VM for Unifi there. It was a bit of an arm
wrestle, not worthy of its own project so I'll document it here since it's
router-adjacent.

## It was all about the cpu flags, when it wasn't all about the failing flash chips

First, default Proxmox PVE VM CPU configuration leaves off most feature flags.
This makes it maximally likely that you can migrate a running machine to another
host (with another physical CPU architecture, though in the same broad family)
and have it run there too. But to their credit there are configuration options
(inherited from QEMU) to turn on pretty much whatever you want - so that's what
I did. The CPU type "host" makes the VM match the host, which barely has SSE and
AVX but apparently it's enough to avoid MongoDB blowing up with SIGILL on
startup (which honestly was pretty mystifying at first). Adopting the U7 Lite
devices wiped them, requiring reconfiguring the APs once I figured out why I'd
lost connectivity. (I didn't sleep much last night, a bit dopey today.)

## Newer Proxmox

That old Dell laptop/server is running Proxmox PVE v7-point-something, which
they prominently say went out of support oh about two years ago. So while I was
screwing around with all this I did some messing about with newer Proxmox,
installing v9.1 on a 2017-era Macbook Pro. This was a rabbit hole too, first
because one of my old laptops apparently has a knackered SSD that blew sector
errors during installation, but otherwise things pretty much followed
proxmox.com instructions (on another machine, apparently without piffled flash).
These boxen don't have Ethernet ports and I'm down to one ancient Thunderbolt
Ethernet dongle, so I probably need to scour Ebay for a few more; and some more
"magsafe" power connectors, nervous-making in a server installation. And so need
maybe also to build a decent rack/box for these things that'll keep the power
cords connected, if I'm going to keep them deployed this way.

## Proxmox cluster?

I'm vaguely interested in clustering two or more of these old machines, mostly
to feel the bits between my toes (but also anticipating the needs of a
makerspace that might or might not come into existence in coming years here). In
the short term doing so would make upgrading the existing installation easier:
migrate all the VMs and containers and such to the new 9.1 install, then
removing the 7.x from the cluster and repaving that one with 9.x also and
joining it in anew.

How hard could it be?
