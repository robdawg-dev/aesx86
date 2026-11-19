# syntax=docker/dockerfile:1

# ---- Build stage -----------------------------------------------------------
# The .asm sources are 32-bit x86 (nasm -f elf) and the C harnesses pass
# `unsigned long *` buffers sized for 4-byte longs, so everything is built
# with -m32. Binaries are linked statically so the runtime image needs no
# 32-bit libc.
FROM debian:bookworm-slim AS build

RUN apt-get update \
 && apt-get install -y --no-install-recommends nasm gcc gcc-multilib libc6-dev-i386 \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /src
COPY rijndael/ rijndael/
COPY serpent/  serpent/
COPY twofish/  twofish/

RUN set -eux; \
    for alg in rijndael serpent twofish; do \
        cd /src/$alg; \
        nasm -f elf32 $alg.asm -o $alg.o; \
        gcc -m32 -std=c99 -c ${alg}Test.c -o ${alg}Test.o; \
        gcc -m32 -static $alg.o ${alg}Test.o -o /src/$alg/$alg; \
    done

# ---- Runtime stage ---------------------------------------------------------
FROM debian:bookworm-slim

COPY --from=build /src/rijndael/rijndael /src/serpent/serpent /src/twofish/twofish /usr/local/bin/
COPY rijndael/ecb_e_m.txt /usr/local/share/aesx86/rijndael.txt
COPY serpent/ecb_e_m.txt  /usr/local/share/aesx86/serpent.txt
COPY twofish/ecb_e_m.txt  /usr/local/share/aesx86/twofish.txt
COPY docker/selftest.sh   /usr/local/bin/selftest
RUN sed -i 's/\r$//' /usr/local/bin/selftest && chmod +x /usr/local/bin/selftest

# Default: verify all three ciphers against the bundled Monte Carlo vectors.
# Run a cipher interactively with:  docker run -it --rm aesx86 rijndael
CMD ["selftest"]
