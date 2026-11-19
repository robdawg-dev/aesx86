#!/bin/sh
# Checks each cipher against the first N entries of its ecb_e_m.txt
# Monte Carlo vectors: CT must match, and decrypting must return the PT.
set -u
N="${1:-5}"
fail=0

for alg in rijndael serpent twofish; do
    file="/usr/local/share/aesx86/$alg.txt"
    # Collect KY/PT/CT triples (strip CRs in case the file has DOS line endings)
    tr -d '\r' < "$file" | awk -F= '
        /^KY=/ {ky=$2} /^PT=/ {pt=$2}
        /^CT=/ {print ky, pt, $2}' | head -n "$N" > /tmp/vectors

    i=0
    while read -r ky pt ct; do
        out=$(printf '%s\n%s\n' "$ky" "$pt" | "$alg")
        got_ct=$(echo "$out" | sed -n 's/.*CT = \([0-9A-F]*\).*/\1/p')
        got_pt=$(echo "$out" | sed -n 's/.*PT = \([0-9A-F]*\).*/\1/p' | tail -n1)
        if [ "$got_ct" = "$ct" ] && [ "$got_pt" = "$pt" ]; then
            echo "PASS $alg I=$i"
        else
            echo "FAIL $alg I=$i  expected CT=$ct got CT=$got_ct, PT=$got_pt"
            fail=1
        fi
        i=$((i + 1))
    done < /tmp/vectors
done

[ "$fail" -eq 0 ] && echo "All tests passed." || echo "Some tests FAILED."
exit "$fail"
