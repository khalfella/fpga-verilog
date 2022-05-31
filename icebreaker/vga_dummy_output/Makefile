PROJ = vga_dummy
ADD_SRC = vga_timing.v
ADD_DEPS = 
ADD_CLEAN = 


PIN_DEF = icebreaker.pcf
DEVICE = up5k
PACKAGE = sg48

prog: iceprog


all: $(PROJ).bin

%.bin: %.asc
	icepack $< $@

%.asc: $(PIN_DEF) %.json
	nextpnr-ice40 --$(DEVICE) \
	$(if $(PACKAGE),--package $(PACKAGE)) \
	--json $(filter-out $<,$^) \
	--pcf $< \
	--asc $@ \
	$(if $(PNR_SEED),--seed $(PNR_SEED))

%.json: %.v $(ADD_SRC) $(ADD_DEPS)
	yosys -ql $*.log -p 'synth_ice40 -top top -json $@' $< $(ADD_SRC)



###########################
####### Test bench
###########################

%_tb: %_tb.v %.v
	iverilog -g2012 -o $@ $^

%_tb.vcd: %_tb
	vvp -N $< +vcd=$@

%_syn.v: %.json
	yosys -p 'read_json $^; write_verilog $@'

%_syntb: %_tb.v %_syn.v
	iverilog -o $@ $^ `yosys-config --datdir/ice40/cells_sim.v`

%_syntb.vcd: %_syntb
	vvp -N $< +vcd=$@


###########################
####### Program FPGA ######
###########################

iceprog: $(PROJ).bin
	iceprog $<

###########################
# The default DFU device is the no2bootloader used by icebreaker-bitsy
###########################

DFU_DEVICE ?= 1d50:6146

dfuprog: $(PROJ).bin
	dfu-util$(if $(DFU_DEVICE), -d $(DFU_DEVICE))$(if $(DFU_SERIAL), -S $(DFU_SERIAL)) -a 0 -D $< -R

sudo-dfuprog: $(PROJ).bin
	@echo 'Executing dfu-util as root!!!'
	sudo dfu-util$(if $(DFU_DEVICE), -d $(DFU_DEVICE))$(if $(DFU_SERIAL), -S $(DFU_SERIAL)) -a 0 -D $< -R

clean:
	rm -f $(PROJ).blif $(PROJ).asc $(PROJ).bin $(PROJ).json $(PROJ).log $(ADD_CLEAN)

.SECONDARY:
.PHONY: all prog clean
.DEFAULT_GOAL := all

