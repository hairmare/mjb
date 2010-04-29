
HAIRMARE_TOPDIR:=.

include $(HAIRMARE_TOPDIR)/hairmare.mk

# setup initial repos 
init: repo/init

# handles repos that are outside of ./scripts/feeds' scope
update: repo/update

world: repo/world
