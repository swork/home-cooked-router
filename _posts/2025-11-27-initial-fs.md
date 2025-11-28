---
title: Initial FS
---
Took a while to get Ansible to build the root image. My efforts weren't helped at all by a batch of flakey
SD cards I've had lying around with sharpie'd question-marks on them - ultimately 100% of the batch
went into the trash.

## SD failure modes

Two of them. In one, the card mounts under Linux as a much smaller filesystem than intended containing a single file, `uupd.bin`, which itself contained nothing I found interesting. This happened repeatedly after imaging, for some of the bad cards.

In the other failure mode, imaging ran to completion and an as-expected root filesystem image mounts when looked at under Linux. But on the OP5+ device, about 2s after beginning the boot cycle the machine apparently powers down abruptly. Nothing left on the screen to diagnose with, no clues at all, and completely repeatable. Reimaging this card with the same bits sometimes repeated the problem, sometimes led to an image that booted further but threw FS errors during the boot process.

## Anyway, continuing...

Here's my FS build procedure:

 - In home-cooked-router repo pull an image into ./images. (The one matching the .sha file already there is the only one I've worked with in this way. I'm not putting the image itself in the repo for various reasons.)

 - Run 'sudo bash ./scripts/make-image.sh' and watch things roll. See the results in ./build on successful completion, or troubleshoot and watch days go by.

 - Make an SD card available, unmounted (on my ubuntu laptop this means 'umount' at shell, not clicking the "Eject" button in the file browser as that action makes the entire block-dev report errors subsequently. I haven't sorted out what subsystem is invoked to blow up access, but it seems to go along with whether a friendly icon for the card appears in the GUI app-dock.)

 - Image the card like this: `dd if=build/(image-name) of=/dev/sda bs=4M` (substitute the right block-dev name or bear substantial consequences).

## Next up

When it succeeds this procedure yields a bootable root FS card with a basic network config for my use and a basic user account for me, including authorizing my SSH key for immediate login.

So next steps will be more Ansible work for post-boot fixups that end with the running router. I can't wait!
