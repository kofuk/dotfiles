#!/usr/bin/env python3
import os
import os.path
import sys

def main():
    if len(sys.argv) >= 2:
        wd = sys.argv[1]
    else:
        wd = os.getcwd()
    home = os.path.expanduser("~")
    if wd.startswith(home):
        is_under_home = True
        wd = "~" + wd[len(home):]
    elif len(wd) > 0:
        is_under_home = False
        wd = wd[1:]
    if len(wd) >= 30:
        segs = wd.split("/")
        if len(segs) <= 2:
            omit_until = 0
        else:
            omit_until = len(segs) - 2
        for i in range(omit_until):
            if len(segs[i]) >= 1:
                segs[i] = segs[i][0]
        if not is_under_home:
            print("/", end="")
        print("/".join(segs), end="")
    else:
        print(wd, end="")

if __name__ == "__main__":
    main()
