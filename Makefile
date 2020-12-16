CFLAGS = -g -std=c99 -O3 -pedantic -Wextra -Wno-unused-parameter -Wno-missing-field-initializers

ERLANG_PATH = $(shell erl -eval 'io:format("~s", [lists:concat([code:root_dir(), "/erts-", erlang:system_info(version), "/include"])])' -s init stop -noshell)
CFLAGS += -I$(ERLANG_PATH)

ifneq ($(OS),Windows_NT)
	CFLAGS += -fPIC

	ifeq ($(shell uname),Darwin)
		LDFLAGS += -dynamiclib -undefined dynamic_lookup
	endif
endif

all: priv/portmidi_in.so priv/portmidi_out.so priv/portmidi_devices.so

priv/portmidi_in.so: src/portmidi_in.c src/portmidi_shared.c
	$(CC) $(CFLAGS) -shared $(LDFLAGS) -o $@ src/portmidi_in.c src/portmidi_shared.c -lportmidi 

priv/portmidi_out.so: src/portmidi_out.c src/portmidi_shared.c
	$(CC) $(CFLAGS) -shared $(LDFLAGS) -o $@ src/portmidi_out.c src/portmidi_shared.c -lportmidi

priv/portmidi_devices.so: src/portmidi_devices.c src/portmidi_shared.c
	$(CC) $(CFLAGS) -shared $(LDFLAGS) -o $@ src/portmidi_devices.c src/portmidi_shared.c -lportmidi
