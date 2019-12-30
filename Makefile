YOSYS_OPTS=PREFIX=$(PWD)/output
ICESTORM_OPTS=PREFIX=$(PWD)/output
NEXTPNR_OPTS=DESTDIR=$(PWD)/output


.PHONY: yosys icestorm nextpnr clean

all: yosys icestorm nextpnr

output:
	mkdir output

build:
	mkdir build


yosys: output
	$(MAKE) -C yosys $(YOSYS_OPTS) config-gcc
	$(MAKE) -C yosys $(YOSYS_OPTS) -j12
	$(MAKE) -C yosys $(YOSYS_OPTS) install

icestorm: output
	$(MAKE) -C icestorm $(ICESTORM_OPTS)
	$(MAKE) -C icestorm $(ICESTORM_OPTS) install

nextpnr: output build
	rm -fr build/nextpnr
	mkdir build/nextpnr
	cd build/nextpnr && cmake -DARCH=ice40 -DICEBOX_ROOT=$(PWD)/output/share/icebox $(PWD)/nextpnr
	$(MAKE) $(NEXTPNR_OPTS) -C build/nextpnr
	$(MAKE) $(NEXTPNR_OPTS) -C build/nextpnr install

clean:
	rm -rf output build
