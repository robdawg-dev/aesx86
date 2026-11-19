# AESx86

Hand-written 32-bit x86 assembly implementations of three AES finalists —
**Rijndael**, **Serpent**, and **Twofish** — with small C harnesses that verify
them against the official NIST Monte Carlo test vectors.

The assembly favors readability over raw speed: the goal is to make each
algorithm's structure easy to follow while still being reasonably fast, and to
show how NASM-assembled code links cleanly into a C program.

| Cipher   | Source                                       | Key size | Block size |
| -------- | -------------------------------------------- | -------- | ---------- |
| Rijndael | [`rijndael/rijndael.asm`](rijndael/rijndael.asm) | 256-bit  | 128-bit    |
| Serpent  | [`serpent/serpent.asm`](serpent/serpent.asm)     | 256-bit  | 128-bit    |
| Twofish  | [`twofish/twofish.asm`](twofish/twofish.asm)     | 256-bit  | 128-bit    |

## Quick start

The easiest way to build and run is with Docker — no local NASM or 32-bit
toolchain required.

```sh
docker build -t aesx86 .
docker run --rm aesx86
```

```
PASS rijndael I=0
...
PASS twofish I=4
All tests passed.
```

### Commands

```sh
docker run --rm aesx86 selftest 50      # verify the first 50 vectors per cipher
docker run -it --rm aesx86 rijndael     # interactive: also serpent, twofish
```

Pipe input instead of typing it:

```sh
printf '%s\n%s\n' \
  0000000000000000000000000000000000000000000000000000000000000000 \
  00000000000000000000000000000000 \
  | docker run -i --rm aesx86 twofish
```

```
KY = PT = CT = 04F2F36CA927AE506931DE8F78B2513C
PT = 00000000000000000000000000000000
```

## How the test works

Each harness reads a 256-bit key (`KY`) and a 128-bit plaintext (`PT`) as hex,
then runs a **Monte Carlo test**:

1. Encrypt the block 10,000 times, feeding each output back in, and print `CT`.
2. Decrypt 10,000 times and print the recovered `PT`, which must match the input.

This mirrors the format of the AES submission test files, so each `CT` can be
checked directly against the bundled `ecb_e_m.txt` (ECB-mode Monte Carlo
vectors). The `selftest` command automates that comparison.

## Building natively

Requires NASM and a gcc that can target 32-bit x86 (on Debian/Ubuntu:
`apt install nasm gcc-multilib`).

```sh
cd rijndael
nasm -f elf32 rijndael.asm -o rijndael.o
gcc -m32 -std=c99 -c rijndaelTest.c -o rijndaelTest.o
gcc -m32 rijndael.o rijndaelTest.o -o rijndael
./rijndael
```

Swap `rijndael` for `serpent` or `twofish` to build the others.

> **Note:** `-m32` is required. The assembly uses 32-bit registers and the
> cdecl calling convention, and the harnesses assume 4-byte `long`s.

## Using the assembly from C

Each `.asm` file exports a small cdecl API. Expand the key once, then
encrypt or decrypt 16-byte blocks in place.

**Rijndael**
```c
void rijndaelGenEncryptKeyAsm(unsigned int *key, unsigned int *expanded); // expanded: 60 words
void rijndaelGenDecryptKeyAsm(unsigned int *key, unsigned int *expanded);
void rijndaelEncrypt(char *block, unsigned long *expanded);
void rijndaelDecrypt(char *block, unsigned long *expanded);
```

**Serpent**
```c
void serpentGenKeyAsm(unsigned int *key, unsigned int *expanded);         // expanded: 132 words
void serpentEncrypt(char *block, char *expanded);
void serpentDecrypt(char *block, char *expanded);
```

**Twofish**
```c
void twofishMakeKeysAndTable(unsigned int *key, unsigned int *expanded,    // expanded: 40 words
                             unsigned int table[4][256]);
void twofishEncrypt(const unsigned int *block, unsigned int *expanded, unsigned int table[4][256]);
void twofishDecrypt(const unsigned int *block, unsigned int *expanded, unsigned int table[4][256]);
```

### Byte order

x86 is little-endian, but parts of these algorithms are specified big-endian.
The harnesses read input with `scanf("%8x")` and byte-swap it so results match
the published vectors. If you only need to round-trip your own data, no
swapping is needed. Just be consistent between encryption and decryption.
Swapping only matters when interoperating with other implementations.

## Project layout

```
.
├── rijndael/          rijndael.asm, test harness, NIST vectors
├── serpent/           serpent.asm, test harness, NIST vectors
├── twofish/           twofish.asm, test harness, NIST vectors
├── docker/            selftest script used by the container
├── Dockerfile
└── *.pdf              algorithm specifications and implementation notes
```

## Caveats

- Only 256-bit keys are supported.
- ECB block operations only. There are no chaining modes (CBC, CTR, etc.).
- This is an educational project and has not been audited for side-channel
  resistance. Don't use it to protect real data.

## License

ISC-style license. See the header of each source file.
Copyright © 2007 Robert W. Waite.
