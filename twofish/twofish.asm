;
;Copyright (c) 2007 Robert W. Waite <winstonwaite@gmail.com>
;
;Permission to use, copy, modify, and distribute this software for any
;purpose with or without fee is hereby granted, provided that the above
;copyright notice and this permission notice appear in all copies.
;
;THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
;WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
;MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
;ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
;WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
;ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
;OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

;genTableRound(round number, table[0][x], table[1][x], table[2][x], table[3][x])
%macro      genTableRound    5

    movzx edi, dl
    xor   edi, [q1+%1]
    and   edi, 0xff
    movzx esi, cl
    xor   esi, [q1+edi]
    and   esi, 0xff
    movzx edi, bl
    xor   edi, [q0+esi]
    and   edi, 0xff
    movzx esi, al
    xor   esi, [q0+edi]
    and   esi, 0xff  
    mov   esi, [m0+esi*4]       
    mov   [ebp+%2], esi
    
    movzx edi, dh
    xor   edi, [q0+%1]
    and   edi, 0xff
    movzx esi, ch
    xor   esi, [q1+edi]
    and   esi, 0xff
    movzx edi, bh
    xor   edi, [q1+esi]
    and   edi, 0xff
    movzx esi, ah
    xor   esi, [q0+edi]
    and   esi, 0xff  
    mov   esi, [m1+esi*4]       
    mov   [ebp+%3], esi
    
    ror   edx, 16
    ror   ecx, 16
    ror   ebx, 16
    ror   eax, 16
    
    movzx edi, dl
    xor   edi, [q0+%1]
    and   edi, 0xff
    movzx esi, cl
    xor   esi, [q0+edi]
    and   esi, 0xff
    movzx edi, bl
    xor   edi, [q0+esi]
    and   edi, 0xff
    movzx esi, al
    xor   esi, [q1+edi]
    and   esi, 0xff  
    mov   esi, [m2+esi*4]       
    mov   [ebp+%4], esi
    
    movzx edi, dh
    xor   edi, [q1+%1]
    and   edi, 0xff
    movzx esi, ch
    xor   esi, [q0+edi]
    and   esi, 0xff
    movzx edi, bh
    xor   edi, [q1+esi]
    and   edi, 0xff
    movzx esi, ah
    xor   esi, [q1+edi]
    and   esi, 0xff  
    mov   esi, [m3+esi*4]       
    mov   [ebp+%5], esi 
    
    ror   edx, 16
    ror   ecx, 16
    ror   ebx, 16
    ror   eax, 16

%endmacro

%macro      h_function      5

    mov   esi, [esp+20]           ;move pointer to key (first arg of function) to ESI   
    mov   eax, [esi+%2]           ;even EAX
    mov   ebx, [esi+%3]           ;even EBX
    mov   ecx, [esi+%4]           ;even ECX
    mov   ebp, [esi+%5]           ;even EBP
          
    mov   edx, [qf+%1*4]
    xor   edx, ebp
          
    movzx esi, dl          
    movzx esi, byte[q1+esi]
    movzx edi, cl
    xor   esi, edi
    movzx esi, byte[q0+esi]
    movzx edi, bl
    xor   esi, edi
    movzx esi, byte[q0+esi]
    movzx edi, al
    xor   esi, edi
    mov   ebp, [m0+esi*4]         
          
    movzx esi, dh
    movzx esi, byte[q1+esi]
    movzx edi, ch
    xor   esi, edi
    movzx esi, byte[q1+esi]
    movzx edi, bh
    xor   esi, edi
    movzx esi, byte[q0+esi]
    movzx edi, ah
    xor   esi, edi
    mov   esi, [m1+esi*4]
    xor   ebp, esi
    
    shr   edx, 16
    shr   ecx, 16
    shr   ebx, 16
    shr   eax, 16
          
    movzx esi, dl             
    movzx esi, byte[q0+esi]
    movzx edi, cl
    xor   esi, edi
    movzx esi, byte[q0+esi]
    movzx edi, bl
    xor   esi, edi
    movzx esi, byte[q1+esi]
    movzx edi, al
    xor   esi, edi
    mov   esi, [m2+esi*4]
    xor   ebp, esi
          
    movzx esi, dh
    movzx esi, byte[q0+esi]
    movzx edi, ch
    xor   esi, edi
    movzx esi, byte[q1+esi]
    movzx edi, bh
    xor   esi, edi
    movzx esi, byte[q1+esi]
    movzx edi, ah
    xor   esi, edi
    mov   esi, [m3+esi*4]
    xor   ebp, esi

%endmacro

%macro      h_tmpStore      1

    mov   edi, [esp+24]
    mov   [edi+%1], ebp

%endmacro

%macro      h_saveValues    2

    mov   edi, [esp+24]         ;no more register pressure
    mov   eax, [edi+%1]         ;even
    mov   ebx, ebp              ;odd
    rol   ebx, 8
          
    mov   ecx, eax
    add   ecx, ebx
    mov   [edi+%1], ecx
    shl   ebx, 1
    add   ebx, eax
    rol   ebx, 9
    mov   [edi+%2], ebx

%endmacro

%macro      mds_rem     1

                mov   ecx, ebx                  ; p0 eax
                shr   ecx, 24                   ; p1 ebx
                shl   ebx, 8                    ; t  ecx
                mov   edx, eax                  ; u  edx
                shr   edx, 24
                or    ebx, edx
                shl   eax, 8
                mov   edx, ecx
                shl   edx, 1
                      
                mov   edi, ecx
                and   edi, 0x80
                cmp   edi, 0
                je    noOverFlow%1
                
                xor   edx, 0x14d
        
noOverFlow%1:   xor   ebx, ecx
                mov   edi, edx
                shl   edi, 16
                xor   ebx, edi
                mov   edi, ecx
                shr   edi, 1
                xor   edx, edi
                and   ecx, 0x01
                cmp   ecx, 0
                je    noUnderflow%1
                
                xor   edx, 0xa6
        
noUnderflow%1:  mov   edi, edx
                shl   edi, 24
                shl   edx, 8
                or    edx, edi
                xor   ebx, edx

%endmacro

%macro      g_function          6
        
        movzx ebx, al
        mov   ecx, [ebp+ebx*4]
        movzx ebx, ah
        mov   ebx, [ebp+ebx*4+1024]     
        xor   ecx, ebx
        shr   eax, 16
        movzx ebx, al
        mov   ebx, [ebp+ebx*4+2048]
        xor   ecx, ebx
        movzx ebx, ah
        mov   ebx, [ebp+ebx*4+3072]
        xor   ecx, ebx              ;now has t0
        
        mov   eax, [esi+%5]
        
        movzx ebx, al
        mov   edx, [ebp+ebx*4+1024]
        movzx ebx, ah
        mov   ebx, [ebp+ebx*4+2048]
        xor   edx, ebx       
        shr   eax, 16       
        movzx ebx, al
        mov   ebx, [ebp+ebx*4+3072]
        xor   edx, ebx
        movzx ebx, ah
        mov   ebx, [ebp+ebx*4]
        xor   edx, ebx              ;now has t1
        
        %6  %1, %2, %3, %4

%endmacro

%macro      encryptSub      4

        mov   eax, [edi+%3]         
        add   eax, ecx
        add   eax, edx
        mov   ebx, [esi+%1]
        xor   eax, ebx
        ror   eax, 1
        mov   [esi+%1], eax
              
        mov   eax, [edi+%4]
        mov   ebx, edx
        shl   ebx, 1                
        add   eax, ebx
        add   eax, ecx
        mov   ebx, [esi+%2]
        rol   ebx, 1
        xor   eax, ebx
        mov   [esi+%2], eax

%endmacro

%macro      decryptSub      4

        mov   eax, [edi+%3]         
        add   eax, ecx
        add   eax, edx
        mov   ebx, [esi+%1]
        rol   ebx, 1
        xor   eax, ebx
        mov   [esi+%1], eax
              
        mov   eax, [edi+%4]
        mov   ebx, edx
        shl   ebx, 1                
        add   eax, ebx
        add   eax, ecx
        mov   ebx, [esi+%2]
        xor   eax, ebx
        ror   eax, 1  
        mov   [esi+%2], eax

%endmacro


section .text
    global twofishMakeKeysAndTable
    global twofishEncrypt
    global twofishDecrypt

        
    twofishMakeKeysAndTable:
    
        push   ebp                    ;save value of registers, we use them all
        push   ebx                    ;save register
        push   esi                    ;save register
        push   edi                    ;save register
        
        ;GENERATE SBOX KEYS
        
        mov   esi, [esp+20]           ;move pointer to key (first arg of function) to ESI   
        mov   eax, [esi]              ;P0
        mov   ebx, [esi+4]            ;P1
        
        mds_rem     1
        mds_rem     2
        mds_rem     3
        mds_rem     4
        mds_rem     5
        mds_rem     6
        mds_rem     7
        mds_rem     8
        
        mov   esi, [esp+28]
        mov   [esi+12], ebx
              
        mov   esi, [esp+20]           ;move pointer to data (first arg of function) to ESI   
        mov   eax, [esi+8]            ;P0
        mov   ebx, [esi+12]           ;P1
        
        mds_rem     9
        mds_rem     10
        mds_rem     11
        mds_rem     12
        mds_rem     13
        mds_rem     14
        mds_rem     15
        mds_rem     16
        
        mov   esi, [esp+28]
        mov   [esi+8], ebx
              
        mov   esi, [esp+20]           ;move pointer to data (first arg of function) to ESI   
        mov   eax, [esi+16]           ;P0
        mov   ebx, [esi+20]           ;P1
        
        mds_rem     17
        mds_rem     18
        mds_rem     19
        mds_rem     20
        mds_rem     21
        mds_rem     22
        mds_rem     23
        mds_rem     24
        
        mov   esi, [esp+28]
        mov   [esi+4], ebx
              
        mov   esi, [esp+20]           ;move pointer to data (first arg of function) to ESI   
        mov   eax, [esi+24]           ;P0
        mov   ebx, [esi+28]           ;P1
        
        mds_rem     25
        mds_rem     26
        mds_rem     27
        mds_rem     28
        mds_rem     29
        mds_rem     30
        mds_rem     31
        mds_rem     32
        
        mov   ebp, [esp+28]
        mov   [ebp], ebx
        
        ;GENERATE TABLE
          
        mov   eax, [ebp]              ;put first 32 bit int in EAX
        mov   ebx, [ebp+4]            ;second in EBX
        mov   ecx, [ebp+8]            ;third in ECX
        mov   edx, [ebp+12]           ;fourth in EDX
        
        genTableRound         0,    0, 1024, 2048, 3072        ; to stop [ebp+%1*4+3072]
        genTableRound         1,    4, 1028, 2052, 3076
        genTableRound         2,    8, 1032, 2056, 3080
        genTableRound         3,   12, 1036, 2060, 3084
        genTableRound         4,   16, 1040, 2064, 3088
        genTableRound         5,   20, 1044, 2068, 3092
        genTableRound         6,   24, 1048, 2072, 3096
        genTableRound         7,   28, 1052, 2076, 3100
        genTableRound         8,   32, 1056, 2080, 3104
        genTableRound         9,   36, 1060, 2084, 3108
        genTableRound        10,   40, 1064, 2088, 3112
        genTableRound        11,   44, 1068, 2092, 3116
        genTableRound        12,   48, 1072, 2096, 3120
        genTableRound        13,   52, 1076, 2100, 3124
        genTableRound        14,   56, 1080, 2104, 3128
        genTableRound        15,   60, 1084, 2108, 3132
        genTableRound        16,   64, 1088, 2112, 3136
        genTableRound        17,   68, 1092, 2116, 3140
        genTableRound        18,   72, 1096, 2120, 3144
        genTableRound        19,   76, 1100, 2124, 3148
        genTableRound        20,   80, 1104, 2128, 3152
        genTableRound        21,   84, 1108, 2132, 3156
        genTableRound        22,   88, 1112, 2136, 3160
        genTableRound        23,   92, 1116, 2140, 3164
        genTableRound        24,   96, 1120, 2144, 3168
        genTableRound        25,  100, 1124, 2148, 3172
        genTableRound        26,  104, 1128, 2152, 3176
        genTableRound        27,  108, 1132, 2156, 3180
        genTableRound        28,  112, 1136, 2160, 3184
        genTableRound        29,  116, 1140, 2164, 3188
        genTableRound        30,  120, 1144, 2168, 3192
        genTableRound        31,  124, 1148, 2172, 3196
        genTableRound        32,  128, 1152, 2176, 3200
        genTableRound        33,  132, 1156, 2180, 3204
        genTableRound        34,  136, 1160, 2184, 3208
        genTableRound        35,  140, 1164, 2188, 3212
        genTableRound        36,  144, 1168, 2192, 3216
        genTableRound        37,  148, 1172, 2196, 3220
        genTableRound        38,  152, 1176, 2200, 3224
        genTableRound        39,  156, 1180, 2204, 3228
        genTableRound        40,  160, 1184, 2208, 3232
        genTableRound        41,  164, 1188, 2212, 3236
        genTableRound        42,  168, 1192, 2216, 3240
        genTableRound        43,  172, 1196, 2220, 3244
        genTableRound        44,  176, 1200, 2224, 3248
        genTableRound        45,  180, 1204, 2228, 3252
        genTableRound        46,  184, 1208, 2232, 3256
        genTableRound        47,  188, 1212, 2236, 3260
        genTableRound        48,  192, 1216, 2240, 3264
        genTableRound        49,  196, 1220, 2244, 3268
        genTableRound        50,  200, 1224, 2248, 3272
        genTableRound        51,  204, 1228, 2252, 3276
        genTableRound        52,  208, 1232, 2256, 3280
        genTableRound        53,  212, 1236, 2260, 3284
        genTableRound        54,  216, 1240, 2264, 3288
        genTableRound        55,  220, 1244, 2268, 3292
        genTableRound        56,  224, 1248, 2272, 3296
        genTableRound        57,  228, 1252, 2276, 3300
        genTableRound        58,  232, 1256, 2280, 3304
        genTableRound        59,  236, 1260, 2284, 3308
        genTableRound        60,  240, 1264, 2288, 3312
        genTableRound        61,  244, 1268, 2292, 3316
        genTableRound        62,  248, 1272, 2296, 3320
        genTableRound        63,  252, 1276, 2300, 3324
        genTableRound        64,  256, 1280, 2304, 3328
        genTableRound        65,  260, 1284, 2308, 3332
        genTableRound        66,  264, 1288, 2312, 3336
        genTableRound        67,  268, 1292, 2316, 3340
        genTableRound        68,  272, 1296, 2320, 3344
        genTableRound        69,  276, 1300, 2324, 3348
        genTableRound        70,  280, 1304, 2328, 3352
        genTableRound        71,  284, 1308, 2332, 3356
        genTableRound        72,  288, 1312, 2336, 3360
        genTableRound        73,  292, 1316, 2340, 3364
        genTableRound        74,  296, 1320, 2344, 3368
        genTableRound        75,  300, 1324, 2348, 3372
        genTableRound        76,  304, 1328, 2352, 3376
        genTableRound        77,  308, 1332, 2356, 3380
        genTableRound        78,  312, 1336, 2360, 3384
        genTableRound        79,  316, 1340, 2364, 3388
        genTableRound        80,  320, 1344, 2368, 3392
        genTableRound        81,  324, 1348, 2372, 3396
        genTableRound        82,  328, 1352, 2376, 3400
        genTableRound        83,  332, 1356, 2380, 3404
        genTableRound        84,  336, 1360, 2384, 3408
        genTableRound        85,  340, 1364, 2388, 3412
        genTableRound        86,  344, 1368, 2392, 3416
        genTableRound        87,  348, 1372, 2396, 3420
        genTableRound        88,  352, 1376, 2400, 3424
        genTableRound        89,  356, 1380, 2404, 3428
        genTableRound        90,  360, 1384, 2408, 3432
        genTableRound        91,  364, 1388, 2412, 3436
        genTableRound        92,  368, 1392, 2416, 3440
        genTableRound        93,  372, 1396, 2420, 3444
        genTableRound        94,  376, 1400, 2424, 3448
        genTableRound        95,  380, 1404, 2428, 3452
        genTableRound        96,  384, 1408, 2432, 3456
        genTableRound        97,  388, 1412, 2436, 3460
        genTableRound        98,  392, 1416, 2440, 3464
        genTableRound        99,  396, 1420, 2444, 3468
        genTableRound       100,  400, 1424, 2448, 3472
        genTableRound       101,  404, 1428, 2452, 3476
        genTableRound       102,  408, 1432, 2456, 3480
        genTableRound       103,  412, 1436, 2460, 3484
        genTableRound       104,  416, 1440, 2464, 3488
        genTableRound       105,  420, 1444, 2468, 3492
        genTableRound       106,  424, 1448, 2472, 3496
        genTableRound       107,  428, 1452, 2476, 3500
        genTableRound       108,  432, 1456, 2480, 3504
        genTableRound       109,  436, 1460, 2484, 3508
        genTableRound       110,  440, 1464, 2488, 3512
        genTableRound       111,  444, 1468, 2492, 3516
        genTableRound       112,  448, 1472, 2496, 3520
        genTableRound       113,  452, 1476, 2500, 3524
        genTableRound       114,  456, 1480, 2504, 3528
        genTableRound       115,  460, 1484, 2508, 3532
        genTableRound       116,  464, 1488, 2512, 3536
        genTableRound       117,  468, 1492, 2516, 3540
        genTableRound       118,  472, 1496, 2520, 3544
        genTableRound       119,  476, 1500, 2524, 3548
        genTableRound       120,  480, 1504, 2528, 3552
        genTableRound       121,  484, 1508, 2532, 3556
        genTableRound       122,  488, 1512, 2536, 3560
        genTableRound       123,  492, 1516, 2540, 3564
        genTableRound       124,  496, 1520, 2544, 3568
        genTableRound       125,  500, 1524, 2548, 3572
        genTableRound       126,  504, 1528, 2552, 3576
        genTableRound       127,  508, 1532, 2556, 3580
        genTableRound       128,  512, 1536, 2560, 3584
        genTableRound       129,  516, 1540, 2564, 3588
        genTableRound       130,  520, 1544, 2568, 3592
        genTableRound       131,  524, 1548, 2572, 3596
        genTableRound       132,  528, 1552, 2576, 3600
        genTableRound       133,  532, 1556, 2580, 3604
        genTableRound       134,  536, 1560, 2584, 3608
        genTableRound       135,  540, 1564, 2588, 3612
        genTableRound       136,  544, 1568, 2592, 3616
        genTableRound       137,  548, 1572, 2596, 3620
        genTableRound       138,  552, 1576, 2600, 3624
        genTableRound       139,  556, 1580, 2604, 3628
        genTableRound       140,  560, 1584, 2608, 3632
        genTableRound       141,  564, 1588, 2612, 3636
        genTableRound       142,  568, 1592, 2616, 3640
        genTableRound       143,  572, 1596, 2620, 3644
        genTableRound       144,  576, 1600, 2624, 3648
        genTableRound       145,  580, 1604, 2628, 3652
        genTableRound       146,  584, 1608, 2632, 3656
        genTableRound       147,  588, 1612, 2636, 3660
        genTableRound       148,  592, 1616, 2640, 3664
        genTableRound       149,  596, 1620, 2644, 3668
        genTableRound       150,  600, 1624, 2648, 3672
        genTableRound       151,  604, 1628, 2652, 3676
        genTableRound       152,  608, 1632, 2656, 3680
        genTableRound       153,  612, 1636, 2660, 3684
        genTableRound       154,  616, 1640, 2664, 3688
        genTableRound       155,  620, 1644, 2668, 3692
        genTableRound       156,  624, 1648, 2672, 3696
        genTableRound       157,  628, 1652, 2676, 3700
        genTableRound       158,  632, 1656, 2680, 3704
        genTableRound       159,  636, 1660, 2684, 3708
        genTableRound       160,  640, 1664, 2688, 3712
        genTableRound       161,  644, 1668, 2692, 3716
        genTableRound       162,  648, 1672, 2696, 3720
        genTableRound       163,  652, 1676, 2700, 3724
        genTableRound       164,  656, 1680, 2704, 3728
        genTableRound       165,  660, 1684, 2708, 3732
        genTableRound       166,  664, 1688, 2712, 3736
        genTableRound       167,  668, 1692, 2716, 3740
        genTableRound       168,  672, 1696, 2720, 3744
        genTableRound       169,  676, 1700, 2724, 3748
        genTableRound       170,  680, 1704, 2728, 3752
        genTableRound       171,  684, 1708, 2732, 3756
        genTableRound       172,  688, 1712, 2736, 3760
        genTableRound       173,  692, 1716, 2740, 3764
        genTableRound       174,  696, 1720, 2744, 3768
        genTableRound       175,  700, 1724, 2748, 3772
        genTableRound       176,  704, 1728, 2752, 3776
        genTableRound       177,  708, 1732, 2756, 3780
        genTableRound       178,  712, 1736, 2760, 3784
        genTableRound       179,  716, 1740, 2764, 3788
        genTableRound       180,  720, 1744, 2768, 3792
        genTableRound       181,  724, 1748, 2772, 3796
        genTableRound       182,  728, 1752, 2776, 3800
        genTableRound       183,  732, 1756, 2780, 3804
        genTableRound       184,  736, 1760, 2784, 3808
        genTableRound       185,  740, 1764, 2788, 3812
        genTableRound       186,  744, 1768, 2792, 3816
        genTableRound       187,  748, 1772, 2796, 3820
        genTableRound       188,  752, 1776, 2800, 3824
        genTableRound       189,  756, 1780, 2804, 3828
        genTableRound       190,  760, 1784, 2808, 3832
        genTableRound       191,  764, 1788, 2812, 3836
        genTableRound       192,  768, 1792, 2816, 3840
        genTableRound       193,  772, 1796, 2820, 3844
        genTableRound       194,  776, 1800, 2824, 3848
        genTableRound       195,  780, 1804, 2828, 3852
        genTableRound       196,  784, 1808, 2832, 3856
        genTableRound       197,  788, 1812, 2836, 3860
        genTableRound       198,  792, 1816, 2840, 3864
        genTableRound       199,  796, 1820, 2844, 3868
        genTableRound       200,  800, 1824, 2848, 3872
        genTableRound       201,  804, 1828, 2852, 3876
        genTableRound       202,  808, 1832, 2856, 3880
        genTableRound       203,  812, 1836, 2860, 3884
        genTableRound       204,  816, 1840, 2864, 3888
        genTableRound       205,  820, 1844, 2868, 3892
        genTableRound       206,  824, 1848, 2872, 3896
        genTableRound       207,  828, 1852, 2876, 3900
        genTableRound       208,  832, 1856, 2880, 3904
        genTableRound       209,  836, 1860, 2884, 3908
        genTableRound       210,  840, 1864, 2888, 3912
        genTableRound       211,  844, 1868, 2892, 3916
        genTableRound       212,  848, 1872, 2896, 3920
        genTableRound       213,  852, 1876, 2900, 3924
        genTableRound       214,  856, 1880, 2904, 3928
        genTableRound       215,  860, 1884, 2908, 3932
        genTableRound       216,  864, 1888, 2912, 3936
        genTableRound       217,  868, 1892, 2916, 3940
        genTableRound       218,  872, 1896, 2920, 3944
        genTableRound       219,  876, 1900, 2924, 3948
        genTableRound       220,  880, 1904, 2928, 3952
        genTableRound       221,  884, 1908, 2932, 3956
        genTableRound       222,  888, 1912, 2936, 3960
        genTableRound       223,  892, 1916, 2940, 3964
        genTableRound       224,  896, 1920, 2944, 3968
        genTableRound       225,  900, 1924, 2948, 3972
        genTableRound       226,  904, 1928, 2952, 3976
        genTableRound       227,  908, 1932, 2956, 3980
        genTableRound       228,  912, 1936, 2960, 3984
        genTableRound       229,  916, 1940, 2964, 3988
        genTableRound       230,  920, 1944, 2968, 3992
        genTableRound       231,  924, 1948, 2972, 3996
        genTableRound       232,  928, 1952, 2976, 4000
        genTableRound       233,  932, 1956, 2980, 4004
        genTableRound       234,  936, 1960, 2984, 4008
        genTableRound       235,  940, 1964, 2988, 4012
        genTableRound       236,  944, 1968, 2992, 4016
        genTableRound       237,  948, 1972, 2996, 4020
        genTableRound       238,  952, 1976, 3000, 4024
        genTableRound       239,  956, 1980, 3004, 4028
        genTableRound       240,  960, 1984, 3008, 4032
        genTableRound       241,  964, 1988, 3012, 4036
        genTableRound       242,  968, 1992, 3016, 4040
        genTableRound       243,  972, 1996, 3020, 4044
        genTableRound       244,  976, 2000, 3024, 4048
        genTableRound       245,  980, 2004, 3028, 4052
        genTableRound       246,  984, 2008, 3032, 4056
        genTableRound       247,  988, 2012, 3036, 4060
        genTableRound       248,  992, 2016, 3040, 4064
        genTableRound       249,  996, 2020, 3044, 4068
        genTableRound       250, 1000, 2024, 3048, 4072
        genTableRound       251, 1004, 2028, 3052, 4076
        genTableRound       252, 1008, 2032, 3056, 4080
        genTableRound       253, 1012, 2036, 3060, 4084
        genTableRound       254, 1016, 2040, 3064, 4088
        genTableRound       255, 1020, 2044, 3068, 4092
        
        ;GENERATE EXPANDED KEYS
        
        h_function      0, 0, 8, 16, 24
        h_tmpStore      0      
        h_function      1, 4, 12, 20, 28  
        h_saveValues    0, 4
        
        h_function      2, 0, 8, 16, 24
        h_tmpStore      8      
        h_function      3, 4, 12, 20, 28  
        h_saveValues    8, 12
        
        h_function      4, 0, 8, 16, 24
        h_tmpStore      16      
        h_function      5, 4, 12, 20, 28  
        h_saveValues    16, 20
        
        h_function      6, 0, 8, 16, 24
        h_tmpStore      24      
        h_function      7, 4, 12, 20, 28  
        h_saveValues    24, 28
        
        h_function      8, 0, 8, 16, 24
        h_tmpStore      32      
        h_function      9, 4, 12, 20, 28  
        h_saveValues    32, 36
        
        h_function      10, 0, 8, 16, 24
        h_tmpStore      40      
        h_function      11, 4, 12, 20, 28  
        h_saveValues    40, 44
        
        h_function      12, 0, 8, 16, 24
        h_tmpStore      48      
        h_function      13, 4, 12, 20, 28  
        h_saveValues    48, 52
        
        h_function      14, 0, 8, 16, 24
        h_tmpStore      56      
        h_function      15, 4, 12, 20, 28  
        h_saveValues    56, 60
        
        h_function      16, 0, 8, 16, 24
        h_tmpStore      64      
        h_function      17, 4, 12, 20, 28  
        h_saveValues    64, 68
        
        h_function      18, 0, 8, 16, 24
        h_tmpStore      72      
        h_function      19, 4, 12, 20, 28  
        h_saveValues    72, 76
        
        h_function      20, 0, 8, 16, 24
        h_tmpStore      80      
        h_function      21, 4, 12, 20, 28  
        h_saveValues    80, 84
        
        h_function      22, 0, 8, 16, 24
        h_tmpStore      88      
        h_function      23, 4, 12, 20, 28  
        h_saveValues    88, 92
        
        h_function      24, 0, 8, 16, 24
        h_tmpStore      96      
        h_function      25, 4, 12, 20, 28  
        h_saveValues    96, 100
        
        h_function      26, 0, 8, 16, 24
        h_tmpStore      104      
        h_function      27, 4, 12, 20, 28  
        h_saveValues    104, 108
        
        h_function      28, 0, 8, 16, 24
        h_tmpStore      112      
        h_function      29, 4, 12, 20, 28  
        h_saveValues    112, 116
        
        h_function      30, 0, 8, 16, 24
        h_tmpStore      120      
        h_function      31, 4, 12, 20, 28  
        h_saveValues    120, 124
        
        h_function      32, 0, 8, 16, 24
        h_tmpStore      128      
        h_function      33, 4, 12, 20, 28  
        h_saveValues    128, 132
        
        h_function      34, 0, 8, 16, 24
        h_tmpStore      136      
        h_function      35, 4, 12, 20, 28  
        h_saveValues    136, 140
        
        h_function      36, 0, 8, 16, 24
        h_tmpStore      144      
        h_function      37, 4, 12, 20, 28  
        h_saveValues    144, 148
        
        h_function      38, 0, 8, 16, 24
        h_tmpStore      152      
        h_function      39, 4, 12, 20, 28  
        h_saveValues    152, 156
        
        pop   edi                     ;restore registers to their values before the call
        pop   esi
        pop   ebx
        pop   ebp

        ret
        
    twofishEncrypt:
    
        push  ebp                     ;save value of registers, we use them all
        push  ebx                     ;save register
        push  esi                     ;save register
        push  edi                     ;save register
        
        mov   esi, [esp+20]           ;pointer to plaintext
        mov   edi, [esp+24]           ;pointer to key 
        mov   ebp, [esp+28]           ;pointer to table
        mov   eax, [esi+12]                
        mov   ebx, [edi+12]
        xor   eax, ebx
        mov   [esi+12], eax
        mov   eax, [esi+8]                
        mov   ebx, [edi+8]
        xor   eax, ebx
        mov   [esi+8], eax
        mov   eax, [esi+4]                
        mov   ebx, [edi+4]
        xor   eax, ebx
        mov   [esi+4], eax
        mov   eax, [esi]                
        mov   ebx, [edi]
        xor   eax, ebx
        mov   [esi], eax                
                
        g_function           8, 12, 32, 36, 4, encryptSub
        mov eax, [esi+8]
        g_function           0,  4, 40, 44, 12, encryptSub
        
        mov eax, [esi]                    
        g_function           8, 12, 48, 52, 4, encryptSub
        mov eax, [esi+8]
        g_function           0,  4, 56, 60, 12, encryptSub
        
        mov eax, [esi]                    
        g_function           8, 12, 64, 68, 4, encryptSub
        mov eax, [esi+8]
        g_function           0,  4, 72, 76, 12, encryptSub
        
        mov eax, [esi]                    
        g_function           8, 12, 80, 84, 4, encryptSub
        mov eax, [esi+8]
        g_function           0,  4, 88, 92, 12, encryptSub
        
        mov eax, [esi]                    
        g_function           8, 12, 96, 100, 4, encryptSub
        mov eax, [esi+8]
        g_function           0,  4, 104, 108, 12, encryptSub
        
        mov eax, [esi]                    
        g_function           8, 12, 112, 116, 4, encryptSub
        mov eax, [esi+8]
        g_function           0,  4, 120, 124, 12, encryptSub
        
        mov eax, [esi]                    
        g_function           8, 12, 128, 132, 4, encryptSub
        mov eax, [esi+8]
        g_function           0,  4, 136, 140, 12, encryptSub
        
        mov eax, [esi]                    
        g_function           8, 12, 144, 148, 4, encryptSub
        mov eax, [esi+8]
        g_function           0,  4, 152, 156, 12, encryptSub
               
        mov   eax, [esi+8]
        mov   ebx, [edi+16]
        xor   eax, ebx              ;eax now holds double word 1 of output
        mov   ebx, [esi]
        mov   edx, [edi+24]
        xor   ebx, edx              ;eax now holds double word 3 of output
        mov   [esi], eax
        mov   [esi+8], ebx
              
        mov   eax, [esi+12]
        mov   ebx, [edi+20]
        xor   eax, ebx              ;eax now holds double word 1 of output
        mov   ebx, [esi+4]
        mov   edx, [edi+28]
        xor   ebx, edx              ;eax now holds double word 3 of output
        mov   [esi+4], eax
        mov   [esi+12], ebx
                
        pop   edi                   ;restore registers to their values before the call
        pop   esi
        pop   ebx
        pop   ebp

        ret
        
        
    twofishDecrypt:
    
        push  ebp                    ;save value of registers, we use them all
        push  ebx                    ;save register
        push  esi                    ;save register
        push  edi                    ;save register
       
        mov   esi, [esp+20]           ;pointer to plaintext
        mov   edi, [esp+24]           ;pointer to key 
        mov   ebp, [esp+28]           ;pointer to table
        mov   eax, [esi+12]                
        mov   ebx, [edi+28]
        xor   eax, ebx
        mov   [esi+12], eax
        mov   eax, [esi+8]                
        mov   ebx, [edi+24]
        xor   eax, ebx
        mov   [esi+8], eax
        mov   eax, [esi+4]                
        mov   ebx, [edi+20]
        xor   eax, ebx
        mov   [esi+4], eax
        mov   eax, [esi]                
        mov   ebx, [edi+16]
        xor   eax, ebx
        mov   [esi], eax                
                
        g_function           8, 12, 152, 156, 4, decryptSub
        mov eax, [esi+8]
        g_function           0,  4, 144, 148, 12, decryptSub
        
        mov eax, [esi]                    
        g_function           8, 12, 136, 140, 4, decryptSub
        mov eax, [esi+8]
        g_function           0,  4, 128, 132, 12, decryptSub
        
        mov eax, [esi]                    
        g_function           8, 12, 120, 124, 4, decryptSub
        mov eax, [esi+8]
        g_function           0,  4, 112, 116, 12, decryptSub
        
        mov eax, [esi]                    
        g_function           8, 12, 104, 108, 4, decryptSub
        mov eax, [esi+8]
        g_function           0,  4, 96, 100, 12, decryptSub
        
        mov eax, [esi]                    
        g_function           8, 12, 88, 92, 4, decryptSub
        mov eax, [esi+8]
        g_function           0,  4, 80, 84, 12, decryptSub
        
        mov eax, [esi]                    
        g_function           8, 12, 72, 76, 4, decryptSub
        mov eax, [esi+8]
        g_function           0,  4, 64, 68, 12, decryptSub
        
        mov eax, [esi]                    
        g_function           8, 12, 56, 60, 4, decryptSub
        mov eax, [esi+8]
        g_function           0,  4, 48, 52, 12, decryptSub
        
        mov eax, [esi]                    
        g_function           8, 12, 40, 44, 4, decryptSub
        mov eax, [esi+8]
        g_function           0,  4, 32, 36, 12, decryptSub
               
        mov   eax, [esi+8]
        mov   ebx, [edi]
        xor   eax, ebx              ;eax now holds double word 1 of output
        mov   ebx, [esi]
        mov   edx, [edi+8]
        xor   ebx, edx              ;eax now holds double word 3 of output
        mov   [esi], eax
        mov   [esi+8], ebx
              
        mov   eax, [esi+12]
        mov   ebx, [edi+4]
        xor   eax, ebx              ;eax now holds double word 1 of output
        mov   ebx, [esi+4]
        mov   edx, [edi+12]
        xor   ebx, edx              ;eax now holds double word 3 of output
        mov   [esi+4], eax
        mov   [esi+12], ebx
               
        pop   edi                   ;restore registers to their values before the call
        pop   esi
        pop   ebx
        pop   ebp

        ret
        
        
section .rodata

q0  db        0xa9,0x67,0xb3,0xe8,0x04,0xfd,0xa3,0x76,0x9a,0x92,0x80,0x78,0xe4,0xdd,0xd1,0x38
    db        0x0d,0xc6,0x35,0x98,0x18,0xf7,0xec,0x6c,0x43,0x75,0x37,0x26,0xfa,0x13,0x94,0x48
    db        0xf2,0xd0,0x8b,0x30,0x84,0x54,0xdf,0x23,0x19,0x5b,0x3d,0x59,0xf3,0xae,0xa2,0x82
    db        0x63,0x01,0x83,0x2e,0xd9,0x51,0x9b,0x7c,0xa6,0xeb,0xa5,0xbe,0x16,0x0c,0xe3,0x61
    db        0xc0,0x8c,0x3a,0xf5,0x73,0x2c,0x25,0x0b,0xbb,0x4e,0x89,0x6b,0x53,0x6a,0xb4,0xf1
    db        0xe1,0xe6,0xbd,0x45,0xe2,0xf4,0xb6,0x66,0xcc,0x95,0x03,0x56,0xd4,0x1c,0x1e,0xd7
    db        0xfb,0xc3,0x8e,0xb5,0xe9,0xcf,0xbf,0xba,0xea,0x77,0x39,0xaf,0x33,0xc9,0x62,0x71
    db        0x81,0x79,0x09,0xad,0x24,0xcd,0xf9,0xd8,0xe5,0xc5,0xb9,0x4d,0x44,0x08,0x86,0xe7
    db        0xa1,0x1d,0xaa,0xed,0x06,0x70,0xb2,0xd2,0x41,0x7b,0xa0,0x11,0x31,0xc2,0x27,0x90
    db        0x20,0xf6,0x60,0xff,0x96,0x5c,0xb1,0xab,0x9e,0x9c,0x52,0x1b,0x5f,0x93,0x0a,0xef
    db        0x91,0x85,0x49,0xee,0x2d,0x4f,0x8f,0x3b,0x47,0x87,0x6d,0x46,0xd6,0x3e,0x69,0x64
    db        0x2a,0xce,0xcb,0x2f,0xfc,0x97,0x05,0x7a,0xac,0x7f,0xd5,0x1a,0x4b,0x0e,0xa7,0x5a
    db        0x28,0x14,0x3f,0x29,0x88,0x3c,0x4c,0x02,0xb8,0xda,0xb0,0x17,0x55,0x1f,0x8a,0x7d
    db        0x57,0xc7,0x8d,0x74,0xb7,0xc4,0x9f,0x72,0x7e,0x15,0x22,0x12,0x58,0x07,0x99,0x34
    db        0x6e,0x50,0xde,0x68,0x65,0xbc,0xdb,0xf8,0xc8,0xa8,0x2b,0x40,0xdc,0xfe,0x32,0xa4
    db        0xca,0x10,0x21,0xf0,0xd3,0x5d,0x0f,0x00,0x6f,0x9d,0x36,0x42,0x4a,0x5e,0xc1,0xe0

    
q1  db        0x75,0xf3,0xc6,0xf4,0xdb,0x7b,0xfb,0xc8,0x4a,0xd3,0xe6,0x6b,0x45,0x7d,0xe8,0x4b
    db        0xd6,0x32,0xd8,0xfd,0x37,0x71,0xf1,0xe1,0x30,0x0f,0xf8,0x1b,0x87,0xfa,0x06,0x3f
    db        0x5e,0xba,0xae,0x5b,0x8a,0x00,0xbc,0x9d,0x6d,0xc1,0xb1,0x0e,0x80,0x5d,0xd2,0xd5
    db        0xa0,0x84,0x07,0x14,0xb5,0x90,0x2c,0xa3,0xb2,0x73,0x4c,0x54,0x92,0x74,0x36,0x51
    db        0x38,0xb0,0xbd,0x5a,0xfc,0x60,0x62,0x96,0x6c,0x42,0xf7,0x10,0x7c,0x28,0x27,0x8c
    db        0x13,0x95,0x9c,0xc7,0x24,0x46,0x3b,0x70,0xca,0xe3,0x85,0xcb,0x11,0xd0,0x93,0xb8
    db        0xa6,0x83,0x20,0xff,0x9f,0x77,0xc3,0xcc,0x03,0x6f,0x08,0xbf,0x40,0xe7,0x2b,0xe2
    db        0x79,0x0c,0xaa,0x82,0x41,0x3a,0xea,0xb9,0xe4,0x9a,0xa4,0x97,0x7e,0xda,0x7a,0x17
    db        0x66,0x94,0xa1,0x1d,0x3d,0xf0,0xde,0xb3,0x0b,0x72,0xa7,0x1c,0xef,0xd1,0x53,0x3e
    db        0x8f,0x33,0x26,0x5f,0xec,0x76,0x2a,0x49,0x81,0x88,0xee,0x21,0xc4,0x1a,0xeb,0xd9
    db        0xc5,0x39,0x99,0xcd,0xad,0x31,0x8b,0x01,0x18,0x23,0xdd,0x1f,0x4e,0x2d,0xf9,0x48
    db        0x4f,0xf2,0x65,0x8e,0x78,0x5c,0x58,0x19,0x8d,0xe5,0x98,0x57,0x67,0x7f,0x05,0x64
    db        0xaf,0x63,0xb6,0xfe,0xf5,0xb7,0x3c,0xa5,0xce,0xe9,0x68,0x44,0xe0,0x4d,0x43,0x69
    db        0x29,0x2e,0xac,0x15,0x59,0xa8,0x0a,0x9e,0x6e,0x47,0xdf,0x34,0x35,0x6a,0xcf,0xdc
    db        0x22,0xc9,0xc0,0x9b,0x89,0xd4,0xed,0xab,0x12,0xa2,0x0d,0x52,0xbb,0x02,0x2f,0xa9
    db        0xd7,0x61,0x1e,0xb4,0x50,0x04,0xf6,0xc2,0x16,0x25,0x86,0x56,0x55,0x09,0xbe,0x91

    
qf  dd        0x75A9A975, 0xF36767F3, 0xC6B3B3C6, 0xF4E8E8F4    
    dd        0xDB0404DB, 0x7BFDFD7B, 0xFBA3A3FB, 0xC87676C8
    dd        0x4A9A9A4A, 0xD39292D3, 0xE68080E6, 0x6B78786B
    dd        0x45E4E445, 0x7DDDDD7D, 0xE8D1D1E8, 0x4B38384B
    dd        0xD60D0DD6, 0x32C6C632, 0xD83535D8, 0xFD9898FD
    dd        0x37181837, 0x71F7F771, 0xF1ECECF1, 0xE16C6CE1
    dd        0x30434330, 0x0F75750F, 0xF83737F8, 0x1B26261B
    dd        0x87FAFA87, 0xFA1313FA, 0x06949406, 0x3F48483F
    dd        0x5EF2F25E, 0xBAD0D0BA, 0xAE8B8BAE, 0x5B30305B
    dd        0x8A84848A, 0x00545400, 0xBCDFDFBC, 0x9D23239D
    dd        0x6D19196D, 0xC15B5BC1, 0xB13D3DB1, 0x0E59590E
    dd        0x80F3F380, 0x5DAEAE5D, 0xD2A2A2D2, 0xD58282D5
    dd        0xA06363A0, 0x84010184, 0x07838307, 0x142E2E14
    dd        0xB5D9D9B5, 0x90515190, 0x2C9B9B2C, 0xA37C7CA3
    dd        0xB2A6A6B2, 0x73EBEB73, 0x4CA5A54C, 0x54BEBE54
    dd        0x92161692, 0x740C0C74, 0x36E3E336, 0x51616151
    dd        0x38C0C038, 0xB08C8CB0, 0xBD3A3ABD, 0x5AF5F55A
    dd        0xFC7373FC, 0x602C2C60, 0x62252562, 0x960B0B96
    dd        0x6CBBBB6C, 0x424E4E42, 0xF78989F7, 0x106B6B10
    dd        0x7C53537C, 0x286A6A28, 0x27B4B427, 0x8CF1F18C
    dd        0x13E1E113, 0x95E6E695, 0x9CBDBD9C, 0xC74545C7
    dd        0x24E2E224, 0x46F4F446, 0x3BB6B63B, 0x70666670
    dd        0xCACCCCCA, 0xE39595E3, 0x85030385, 0xCB5656CB
    dd        0x11D4D411, 0xD01C1CD0, 0x931E1E93, 0xB8D7D7B8
    dd        0xA6FBFBA6, 0x83C3C383, 0x208E8E20, 0xFFB5B5FF
    dd        0x9FE9E99F, 0x77CFCF77, 0xC3BFBFC3, 0xCCBABACC
    dd        0x03EAEA03, 0x6F77776F, 0x08393908, 0xBFAFAFBF
    dd        0x40333340, 0xE7C9C9E7, 0x2B62622B, 0xE27171E2
    dd        0x79818179, 0x0C79790C, 0xAA0909AA, 0x82ADAD82
    dd        0x41242441, 0x3ACDCD3A, 0xEAF9F9EA, 0xB9D8D8B9
    dd        0xE4E5E5E4, 0x9AC5C59A, 0xA4B9B9A4, 0x974D4D97
    dd        0x7E44447E, 0xDA0808DA, 0x7A86867A, 0x17E7E717
    dd        0x66A1A166, 0x941D1D94, 0xA1AAAAA1, 0x1DEDED1D
    dd        0x3D06063D, 0xF07070F0, 0xDEB2B2DE, 0xB3D2D2B3
    dd        0x0B41410B, 0x727B7B72, 0xA7A0A0A7, 0x1C11111C
    dd        0xEF3131EF, 0xD1C2C2D1, 0x53272753, 0x3E90903E
    dd        0x8F20208F, 0x33F6F633, 0x26606026, 0x5FFFFF5F
    dd        0xEC9696EC, 0x765C5C76, 0x2AB1B12A, 0x49ABAB49
    dd        0x819E9E81, 0x889C9C88, 0xEE5252EE, 0x211B1B21
    dd        0xC45F5FC4, 0x1A93931A, 0xEB0A0AEB, 0xD9EFEFD9
    dd        0xC59191C5, 0x39858539, 0x99494999, 0xCDEEEECD
    dd        0xAD2D2DAD, 0x314F4F31, 0x8B8F8F8B, 0x013B3B01
    dd        0x18474718, 0x23878723, 0xDD6D6DDD, 0x1F46461F
    dd        0x4ED6D64E, 0x2D3E3E2D, 0xF96969F9, 0x48646448
    dd        0x4F2A2A4F, 0xF2CECEF2, 0x65CBCB65, 0x8E2F2F8E
    dd        0x78FCFC78, 0x5C97975C, 0x58050558, 0x197A7A19
    dd        0x8DACAC8D, 0xE57F7FE5, 0x98D5D598, 0x571A1A57
    dd        0x674B4B67, 0x7F0E0E7F, 0x05A7A705, 0x645A5A64
    dd        0xAF2828AF, 0x63141463, 0xB63F3FB6, 0xFE2929FE
    dd        0xF58888F5, 0xB73C3CB7, 0x3C4C4C3C, 0xA50202A5
    dd        0xCEB8B8CE, 0xE9DADAE9, 0x68B0B068, 0x44171744
    dd        0xE05555E0, 0x4D1F1F4D, 0x438A8A43, 0x697D7D69
    dd        0x29575729, 0x2EC7C72E, 0xAC8D8DAC, 0x15747415
    dd        0x59B7B759, 0xA8C4C4A8, 0x0A9F9F0A, 0x9E72729E
    dd        0x6E7E7E6E, 0x47151547, 0xDF2222DF, 0x34121234
    dd        0x35585835, 0x6A07076A, 0xCF9999CF, 0xDC3434DC
    dd        0x226E6E22, 0xC95050C9, 0xC0DEDEC0, 0x9B68689B
    dd        0x89656589, 0xD4BCBCD4, 0xEDDBDBED, 0xABF8F8AB
    dd        0x12C8C812, 0xA2A8A8A2, 0x0D2B2B0D, 0x52404052
    dd        0xBBDCDCBB, 0x02FEFE02, 0x2F32322F, 0xA9A4A4A9
    dd        0xD7CACAD7, 0x61101061, 0x1E21211E, 0xB4F0F0B4
    dd        0x50D3D350, 0x045D5D04, 0xF60F0FF6, 0xC20000C2
    dd        0x166F6F16, 0x259D9D25, 0x86363686, 0x56424256
    dd        0x554A4A55, 0x095E5E09, 0xBEC1C1BE, 0x91E0E091
    
m0  dd        0xBCBC3275, 0xECEC21F3, 0x202043C6, 0xB3B3C9F4
    dd        0xDADA03DB, 0x02028B7B, 0xE2E22BFB, 0x9E9EFAC8
    dd        0xC9C9EC4A, 0xD4D409D3, 0x18186BE6, 0x1E1E9F6B
    dd        0x98980E45, 0xB2B2387D, 0xA6A6D2E8, 0x2626B74B
    dd        0x3C3C57D6, 0x93938A32, 0x8282EED8, 0x525298FD
    dd        0x7B7BD437, 0xBBBB3771, 0x5B5B97F1, 0x474783E1
    dd        0x24243C30, 0x5151E20F, 0xBABAC6F8, 0x4A4AF31B
    dd        0xBFBF4887, 0x0D0D70FA, 0xB0B0B306, 0x7575DE3F
    dd        0xD2D2FD5E, 0x7D7D20BA, 0x666631AE, 0x3A3AA35B
    dd        0x59591C8A, 0x00000000, 0xCDCD93BC, 0x1A1AE09D
    dd        0xAEAE2C6D, 0x7F7FABC1, 0x2B2BC7B1, 0xBEBEB90E
    dd        0xE0E0A080, 0x8A8A105D, 0x3B3B52D2, 0x6464BAD5
    dd        0xD8D888A0, 0xE7E7A584, 0x5F5FE807, 0x1B1B1114
    dd        0x2C2CC2B5, 0xFCFCB490, 0x3131272C, 0x808065A3
    dd        0x73732AB2, 0x0C0C8173, 0x79795F4C, 0x6B6B4154
    dd        0x4B4B0292, 0x53536974, 0x94948F36, 0x83831F51
    dd        0x2A2A3638, 0xC4C49CB0, 0x2222C8BD, 0xD5D5F85A
    dd        0xBDBDC3FC, 0x48487860, 0xFFFFCE62, 0x4C4C0796
    dd        0x4141776C, 0xC7C7E642, 0xEBEB24F7, 0x1C1C1410
    dd        0x5D5D637C, 0x36362228, 0x6767C027, 0xE9E9AF8C
    dd        0x4444F913, 0x1414EA95, 0xF5F5BB9C, 0xCFCF18C7
    dd        0x3F3F2D24, 0xC0C0E346, 0x7272DB3B, 0x54546C70
    dd        0x29294CCA, 0xF0F035E3, 0x0808FE85, 0xC6C617CB
    dd        0xF3F34F11, 0x8C8CE4D0, 0xA4A45993, 0xCACA96B8
    dd        0x68683BA6, 0xB8B84D83, 0x38382820, 0xE5E52EFF
    dd        0xADAD569F, 0x0B0B8477, 0xC8C81DC3, 0x9999FFCC
    dd        0x5858ED03, 0x19199A6F, 0x0E0E0A08, 0x95957EBF
    dd        0x70705040, 0xF7F730E7, 0x6E6ECF2B, 0x1F1F6EE2
    dd        0xB5B53D79, 0x09090F0C, 0x616134AA, 0x57571682
    dd        0x9F9F0B41, 0x9D9D803A, 0x111164EA, 0x2525CDB9
    dd        0xAFAFDDE4, 0x4545089A, 0xDFDF8DA4, 0xA3A35C97
    dd        0xEAEAD57E, 0x353558DA, 0xEDEDD07A, 0x4343FC17
    dd        0xF8F8CB66, 0xFBFBB194, 0x3737D3A1, 0xFAFA401D
    dd        0xC2C2683D, 0xB4B4CCF0, 0x32325DDE, 0x9C9C71B3
    dd        0x5656E70B, 0xE3E3DA72, 0x878760A7, 0x15151B1C
    dd        0xF9F93AEF, 0x6363BFD1, 0x3434A953, 0x9A9A853E
    dd        0xB1B1428F, 0x7C7CD133, 0x88889B26, 0x3D3DA65F
    dd        0xA1A1D7EC, 0xE4E4DF76, 0x8181942A, 0x91910149
    dd        0x0F0FFB81, 0xEEEEAA88, 0x161661EE, 0xD7D77321
    dd        0x9797F5C4, 0xA5A5A81A, 0xFEFE3FEB, 0x6D6DB5D9
    dd        0x7878AEC5, 0xC5C56D39, 0x1D1DE599, 0x7676A4CD
    dd        0x3E3EDCAD, 0xCBCB6731, 0xB6B6478B, 0xEFEF5B01
    dd        0x12121E18, 0x6060C523, 0x6A6AB0DD, 0x4D4DF61F
    dd        0xCECEE94E, 0xDEDE7C2D, 0x55559DF9, 0x7E7E5A48
    dd        0x2121B24F, 0x03037AF2, 0xA0A02665, 0x5E5E198E
    dd        0x5A5A6678, 0x65654B5C, 0x62624E58, 0xFDFD4519
    dd        0x0606F48D, 0x404086E5, 0xF2F2BE98, 0x3333AC57
    dd        0x17179067, 0x05058E7F, 0xE8E85E05, 0x4F4F7D64
    dd        0x89896AAF, 0x10109563, 0x74742FB6, 0x0A0A75FE
    dd        0x5C5C92F5, 0x9B9B74B7, 0x2D2D333C, 0x3030D6A5
    dd        0x2E2E49CE, 0x494989E9, 0x46467268, 0x77775544
    dd        0xA8A8D8E0, 0x9696044D, 0x2828BD43, 0xA9A92969
    dd        0xD9D97929, 0x8686912E, 0xD1D187AC, 0xF4F44A15
    dd        0x8D8D1559, 0xD6D682A8, 0xB9B9BC0A, 0x42420D9E
    dd        0xF6F6C16E, 0x2F2FB847, 0xDDDD06DF, 0x23233934
    dd        0xCCCC6235, 0xF1F1C46A, 0xC1C112CF, 0x8585EBDC
    dd        0x8F8F9E22, 0x7171A1C9, 0x9090F0C0, 0xAAAA539B
    dd        0x0101F189, 0x8B8BE1D4, 0x4E4E8CED, 0x8E8E6FAB
    dd        0xABABA212, 0x6F6F3EA2, 0xE6E6540D, 0xDBDBF252
    dd        0x92927BBB, 0xB7B7B602, 0x6969CA2F, 0x3939D9A9
    dd        0xD3D30CD7, 0xA7A72361, 0xA2A2AD1E, 0xC3C399B4
    dd        0x6C6C4450, 0x07070504, 0x04047FF6, 0x272746C2
    dd        0xACACA716, 0xD0D07625, 0x50501386, 0xDCDCF756
    dd        0x84841A55, 0xE1E15109, 0x7A7A25BE, 0x1313EF91

m1  dd        0xA9D93939, 0x67901717, 0xB3719C9C, 0xE8D2A6A6
    dd        0x04050707, 0xFD985252, 0xA3658080, 0x76DFE4E4
    dd        0x9A084545, 0x92024B4B, 0x80A0E0E0, 0x78665A5A
    dd        0xE4DDAFAF, 0xDDB06A6A, 0xD1BF6363, 0x38362A2A
    dd        0x0D54E6E6, 0xC6432020, 0x3562CCCC, 0x98BEF2F2
    dd        0x181E1212, 0xF724EBEB, 0xECD7A1A1, 0x6C774141
    dd        0x43BD2828, 0x7532BCBC, 0x37D47B7B, 0x269B8888
    dd        0xFA700D0D, 0x13F94444, 0x94B1FBFB, 0x485A7E7E
    dd        0xF27A0303, 0xD0E48C8C, 0x8B47B6B6, 0x303C2424
    dd        0x84A5E7E7, 0x54416B6B, 0xDF06DDDD, 0x23C56060
    dd        0x1945FDFD, 0x5BA33A3A, 0x3D68C2C2, 0x59158D8D
    dd        0xF321ECEC, 0xAE316666, 0xA23E6F6F, 0x82165757
    dd        0x63951010, 0x015BEFEF, 0x834DB8B8, 0x2E918686
    dd        0xD9B56D6D, 0x511F8383, 0x9B53AAAA, 0x7C635D5D
    dd        0xA63B6868, 0xEB3FFEFE, 0xA5D63030, 0xBE257A7A
    dd        0x16A7ACAC, 0x0C0F0909, 0xE335F0F0, 0x6123A7A7
    dd        0xC0F09090, 0x8CAFE9E9, 0x3A809D9D, 0xF5925C5C
    dd        0x73810C0C, 0x2C273131, 0x2576D0D0, 0x0BE75656
    dd        0xBB7B9292, 0x4EE9CECE, 0x89F10101, 0x6B9F1E1E
    dd        0x53A93434, 0x6AC4F1F1, 0xB499C3C3, 0xF1975B5B
    dd        0xE1834747, 0xE66B1818, 0xBDC82222, 0x450E9898
    dd        0xE26E1F1F, 0xF4C9B3B3, 0xB62F7474, 0x66CBF8F8
    dd        0xCCFF9999, 0x95EA1414, 0x03ED5858, 0x56F7DCDC
    dd        0xD4E18B8B, 0x1C1B1515, 0x1EADA2A2, 0xD70CD3D3
    dd        0xFB2BE2E2, 0xC31DC8C8, 0x8E195E5E, 0xB5C22C2C
    dd        0xE9894949, 0xCF12C1C1, 0xBF7E9595, 0xBA207D7D
    dd        0xEA641111, 0x77840B0B, 0x396DC5C5, 0xAF6A8989
    dd        0x33D17C7C, 0xC9A17171, 0x62CEFFFF, 0x7137BBBB
    dd        0x81FB0F0F, 0x793DB5B5, 0x0951E1E1, 0xADDC3E3E
    dd        0x242D3F3F, 0xCDA47676, 0xF99D5555, 0xD8EE8282
    dd        0xE5864040, 0xC5AE7878, 0xB9CD2525, 0x4D049696
    dd        0x44557777, 0x080A0E0E, 0x86135050, 0xE730F7F7
    dd        0xA1D33737, 0x1D40FAFA, 0xAA346161, 0xED8C4E4E
    dd        0x06B3B0B0, 0x706C5454, 0xB22A7373, 0xD2523B3B
    dd        0x410B9F9F, 0x7B8B0202, 0xA088D8D8, 0x114FF3F3
    dd        0x3167CBCB, 0xC2462727, 0x27C06767, 0x90B4FCFC
    dd        0x20283838, 0xF67F0404, 0x60784848, 0xFF2EE5E5
    dd        0x96074C4C, 0x5C4B6565, 0xB1C72B2B, 0xAB6F8E8E
    dd        0x9E0D4242, 0x9CBBF5F5, 0x52F2DBDB, 0x1BF34A4A
    dd        0x5FA63D3D, 0x9359A4A4, 0x0ABCB9B9, 0xEF3AF9F9
    dd        0x91EF1313, 0x85FE0808, 0x49019191, 0xEE611616
    dd        0x2D7CDEDE, 0x4FB22121, 0x8F42B1B1, 0x3BDB7272
    dd        0x47B82F2F, 0x8748BFBF, 0x6D2CAEAE, 0x46E3C0C0
    dd        0xD6573C3C, 0x3E859A9A, 0x6929A9A9, 0x647D4F4F
    dd        0x2A948181, 0xCE492E2E, 0xCB17C6C6, 0x2FCA6969
    dd        0xFCC3BDBD, 0x975CA3A3, 0x055EE8E8, 0x7AD0EDED
    dd        0xAC87D1D1, 0x7F8E0505, 0xD5BA6464, 0x1AA8A5A5
    dd        0x4BB72626, 0x0EB9BEBE, 0xA7608787, 0x5AF8D5D5
    dd        0x28223636, 0x14111B1B, 0x3FDE7575, 0x2979D9D9
    dd        0x88AAEEEE, 0x3C332D2D, 0x4C5F7979, 0x02B6B7B7
    dd        0xB896CACA, 0xDA583535, 0xB09CC4C4, 0x17FC4343
    dd        0x551A8484, 0x1FF64D4D, 0x8A1C5959, 0x7D38B2B2
    dd        0x57AC3333, 0xC718CFCF, 0x8DF40606, 0x74695353
    dd        0xB7749B9B, 0xC4F59797, 0x9F56ADAD, 0x72DAE3E3
    dd        0x7ED5EAEA, 0x154AF4F4, 0x229E8F8F, 0x12A2ABAB
    dd        0x584E6262, 0x07E85F5F, 0x99E51D1D, 0x34392323
    dd        0x6EC1F6F6, 0x50446C6C, 0xDE5D3232, 0x68724646
    dd        0x6526A0A0, 0xBC93CDCD, 0xDB03DADA, 0xF8C6BABA
    dd        0xC8FA9E9E, 0xA882D6D6, 0x2BCF6E6E, 0x40507070
    dd        0xDCEB8585, 0xFE750A0A, 0x328A9393, 0xA48DDFDF
    dd        0xCA4C2929, 0x10141C1C, 0x2173D7D7, 0xF0CCB4B4
    dd        0xD309D4D4, 0x5D108A8A, 0x0FE25151, 0x00000000
    dd        0x6F9A1919, 0x9DE01A1A, 0x368F9494, 0x42E6C7C7
    dd        0x4AECC9C9, 0x5EFDD2D2, 0xC1AB7F7F, 0xE0D8A8A8

m2  dd        0xBC75BC32, 0xECF3EC21, 0x20C62043, 0xB3F4B3C9
    dd        0xDADBDA03, 0x027B028B, 0xE2FBE22B, 0x9EC89EFA
    dd        0xC94AC9EC, 0xD4D3D409, 0x18E6186B, 0x1E6B1E9F
    dd        0x9845980E, 0xB27DB238, 0xA6E8A6D2, 0x264B26B7
    dd        0x3CD63C57, 0x9332938A, 0x82D882EE, 0x52FD5298
    dd        0x7B377BD4, 0xBB71BB37, 0x5BF15B97, 0x47E14783
    dd        0x2430243C, 0x510F51E2, 0xBAF8BAC6, 0x4A1B4AF3
    dd        0xBF87BF48, 0x0DFA0D70, 0xB006B0B3, 0x753F75DE
    dd        0xD25ED2FD, 0x7DBA7D20, 0x66AE6631, 0x3A5B3AA3
    dd        0x598A591C, 0x00000000, 0xCDBCCD93, 0x1A9D1AE0
    dd        0xAE6DAE2C, 0x7FC17FAB, 0x2BB12BC7, 0xBE0EBEB9
    dd        0xE080E0A0, 0x8A5D8A10, 0x3BD23B52, 0x64D564BA
    dd        0xD8A0D888, 0xE784E7A5, 0x5F075FE8, 0x1B141B11
    dd        0x2CB52CC2, 0xFC90FCB4, 0x312C3127, 0x80A38065
    dd        0x73B2732A, 0x0C730C81, 0x794C795F, 0x6B546B41
    dd        0x4B924B02, 0x53745369, 0x9436948F, 0x8351831F
    dd        0x2A382A36, 0xC4B0C49C, 0x22BD22C8, 0xD55AD5F8
    dd        0xBDFCBDC3, 0x48604878, 0xFF62FFCE, 0x4C964C07
    dd        0x416C4177, 0xC742C7E6, 0xEBF7EB24, 0x1C101C14
    dd        0x5D7C5D63, 0x36283622, 0x672767C0, 0xE98CE9AF
    dd        0x441344F9, 0x149514EA, 0xF59CF5BB, 0xCFC7CF18
    dd        0x3F243F2D, 0xC046C0E3, 0x723B72DB, 0x5470546C
    dd        0x29CA294C, 0xF0E3F035, 0x088508FE, 0xC6CBC617
    dd        0xF311F34F, 0x8CD08CE4, 0xA493A459, 0xCAB8CA96
    dd        0x68A6683B, 0xB883B84D, 0x38203828, 0xE5FFE52E
    dd        0xAD9FAD56, 0x0B770B84, 0xC8C3C81D, 0x99CC99FF
    dd        0x580358ED, 0x196F199A, 0x0E080E0A, 0x95BF957E
    dd        0x70407050, 0xF7E7F730, 0x6E2B6ECF, 0x1FE21F6E
    dd        0xB579B53D, 0x090C090F, 0x61AA6134, 0x57825716
    dd        0x9F419F0B, 0x9D3A9D80, 0x11EA1164, 0x25B925CD
    dd        0xAFE4AFDD, 0x459A4508, 0xDFA4DF8D, 0xA397A35C
    dd        0xEA7EEAD5, 0x35DA3558, 0xED7AEDD0, 0x431743FC
    dd        0xF866F8CB, 0xFB94FBB1, 0x37A137D3, 0xFA1DFA40
    dd        0xC23DC268, 0xB4F0B4CC, 0x32DE325D, 0x9CB39C71
    dd        0x560B56E7, 0xE372E3DA, 0x87A78760, 0x151C151B
    dd        0xF9EFF93A, 0x63D163BF, 0x345334A9, 0x9A3E9A85
    dd        0xB18FB142, 0x7C337CD1, 0x8826889B, 0x3D5F3DA6
    dd        0xA1ECA1D7, 0xE476E4DF, 0x812A8194, 0x91499101
    dd        0x0F810FFB, 0xEE88EEAA, 0x16EE1661, 0xD721D773
    dd        0x97C497F5, 0xA51AA5A8, 0xFEEBFE3F, 0x6DD96DB5
    dd        0x78C578AE, 0xC539C56D, 0x1D991DE5, 0x76CD76A4
    dd        0x3EAD3EDC, 0xCB31CB67, 0xB68BB647, 0xEF01EF5B
    dd        0x1218121E, 0x602360C5, 0x6ADD6AB0, 0x4D1F4DF6
    dd        0xCE4ECEE9, 0xDE2DDE7C, 0x55F9559D, 0x7E487E5A
    dd        0x214F21B2, 0x03F2037A, 0xA065A026, 0x5E8E5E19
    dd        0x5A785A66, 0x655C654B, 0x6258624E, 0xFD19FD45
    dd        0x068D06F4, 0x40E54086, 0xF298F2BE, 0x335733AC
    dd        0x17671790, 0x057F058E, 0xE805E85E, 0x4F644F7D
    dd        0x89AF896A, 0x10631095, 0x74B6742F, 0x0AFE0A75
    dd        0x5CF55C92, 0x9BB79B74, 0x2D3C2D33, 0x30A530D6
    dd        0x2ECE2E49, 0x49E94989, 0x46684672, 0x77447755
    dd        0xA8E0A8D8, 0x964D9604, 0x284328BD, 0xA969A929
    dd        0xD929D979, 0x862E8691, 0xD1ACD187, 0xF415F44A
    dd        0x8D598D15, 0xD6A8D682, 0xB90AB9BC, 0x429E420D
    dd        0xF66EF6C1, 0x2F472FB8, 0xDDDFDD06, 0x23342339
    dd        0xCC35CC62, 0xF16AF1C4, 0xC1CFC112, 0x85DC85EB
    dd        0x8F228F9E, 0x71C971A1, 0x90C090F0, 0xAA9BAA53
    dd        0x018901F1, 0x8BD48BE1, 0x4EED4E8C, 0x8EAB8E6F
    dd        0xAB12ABA2, 0x6FA26F3E, 0xE60DE654, 0xDB52DBF2
    dd        0x92BB927B, 0xB702B7B6, 0x692F69CA, 0x39A939D9
    dd        0xD3D7D30C, 0xA761A723, 0xA21EA2AD, 0xC3B4C399
    dd        0x6C506C44, 0x07040705, 0x04F6047F, 0x27C22746
    dd        0xAC16ACA7, 0xD025D076, 0x50865013, 0xDC56DCF7
    dd        0x8455841A, 0xE109E151, 0x7ABE7A25, 0x139113EF

m3  dd        0xD939A9D9, 0x90176790, 0x719CB371, 0xD2A6E8D2
    dd        0x05070405, 0x9852FD98, 0x6580A365, 0xDFE476DF
    dd        0x08459A08, 0x024B9202, 0xA0E080A0, 0x665A7866
    dd        0xDDAFE4DD, 0xB06ADDB0, 0xBF63D1BF, 0x362A3836
    dd        0x54E60D54, 0x4320C643, 0x62CC3562, 0xBEF298BE
    dd        0x1E12181E, 0x24EBF724, 0xD7A1ECD7, 0x77416C77
    dd        0xBD2843BD, 0x32BC7532, 0xD47B37D4, 0x9B88269B
    dd        0x700DFA70, 0xF94413F9, 0xB1FB94B1, 0x5A7E485A
    dd        0x7A03F27A, 0xE48CD0E4, 0x47B68B47, 0x3C24303C
    dd        0xA5E784A5, 0x416B5441, 0x06DDDF06, 0xC56023C5
    dd        0x45FD1945, 0xA33A5BA3, 0x68C23D68, 0x158D5915
    dd        0x21ECF321, 0x3166AE31, 0x3E6FA23E, 0x16578216
    dd        0x95106395, 0x5BEF015B, 0x4DB8834D, 0x91862E91
    dd        0xB56DD9B5, 0x1F83511F, 0x53AA9B53, 0x635D7C63
    dd        0x3B68A63B, 0x3FFEEB3F, 0xD630A5D6, 0x257ABE25
    dd        0xA7AC16A7, 0x0F090C0F, 0x35F0E335, 0x23A76123
    dd        0xF090C0F0, 0xAFE98CAF, 0x809D3A80, 0x925CF592
    dd        0x810C7381, 0x27312C27, 0x76D02576, 0xE7560BE7
    dd        0x7B92BB7B, 0xE9CE4EE9, 0xF10189F1, 0x9F1E6B9F
    dd        0xA93453A9, 0xC4F16AC4, 0x99C3B499, 0x975BF197
    dd        0x8347E183, 0x6B18E66B, 0xC822BDC8, 0x0E98450E
    dd        0x6E1FE26E, 0xC9B3F4C9, 0x2F74B62F, 0xCBF866CB
    dd        0xFF99CCFF, 0xEA1495EA, 0xED5803ED, 0xF7DC56F7
    dd        0xE18BD4E1, 0x1B151C1B, 0xADA21EAD, 0x0CD3D70C
    dd        0x2BE2FB2B, 0x1DC8C31D, 0x195E8E19, 0xC22CB5C2
    dd        0x8949E989, 0x12C1CF12, 0x7E95BF7E, 0x207DBA20
    dd        0x6411EA64, 0x840B7784, 0x6DC5396D, 0x6A89AF6A
    dd        0xD17C33D1, 0xA171C9A1, 0xCEFF62CE, 0x37BB7137
    dd        0xFB0F81FB, 0x3DB5793D, 0x51E10951, 0xDC3EADDC
    dd        0x2D3F242D, 0xA476CDA4, 0x9D55F99D, 0xEE82D8EE
    dd        0x8640E586, 0xAE78C5AE, 0xCD25B9CD, 0x04964D04
    dd        0x55774455, 0x0A0E080A, 0x13508613, 0x30F7E730
    dd        0xD337A1D3, 0x40FA1D40, 0x3461AA34, 0x8C4EED8C
    dd        0xB3B006B3, 0x6C54706C, 0x2A73B22A, 0x523BD252
    dd        0x0B9F410B, 0x8B027B8B, 0x88D8A088, 0x4FF3114F
    dd        0x67CB3167, 0x4627C246, 0xC06727C0, 0xB4FC90B4
    dd        0x28382028, 0x7F04F67F, 0x78486078, 0x2EE5FF2E
    dd        0x074C9607, 0x4B655C4B, 0xC72BB1C7, 0x6F8EAB6F
    dd        0x0D429E0D, 0xBBF59CBB, 0xF2DB52F2, 0xF34A1BF3
    dd        0xA63D5FA6, 0x59A49359, 0xBCB90ABC, 0x3AF9EF3A
    dd        0xEF1391EF, 0xFE0885FE, 0x01914901, 0x6116EE61
    dd        0x7CDE2D7C, 0xB2214FB2, 0x42B18F42, 0xDB723BDB
    dd        0xB82F47B8, 0x48BF8748, 0x2CAE6D2C, 0xE3C046E3
    dd        0x573CD657, 0x859A3E85, 0x29A96929, 0x7D4F647D
    dd        0x94812A94, 0x492ECE49, 0x17C6CB17, 0xCA692FCA
    dd        0xC3BDFCC3, 0x5CA3975C, 0x5EE8055E, 0xD0ED7AD0
    dd        0x87D1AC87, 0x8E057F8E, 0xBA64D5BA, 0xA8A51AA8
    dd        0xB7264BB7, 0xB9BE0EB9, 0x6087A760, 0xF8D55AF8
    dd        0x22362822, 0x111B1411, 0xDE753FDE, 0x79D92979
    dd        0xAAEE88AA, 0x332D3C33, 0x5F794C5F, 0xB6B702B6
    dd        0x96CAB896, 0x5835DA58, 0x9CC4B09C, 0xFC4317FC
    dd        0x1A84551A, 0xF64D1FF6, 0x1C598A1C, 0x38B27D38
    dd        0xAC3357AC, 0x18CFC718, 0xF4068DF4, 0x69537469
    dd        0x749BB774, 0xF597C4F5, 0x56AD9F56, 0xDAE372DA
    dd        0xD5EA7ED5, 0x4AF4154A, 0x9E8F229E, 0xA2AB12A2
    dd        0x4E62584E, 0xE85F07E8, 0xE51D99E5, 0x39233439
    dd        0xC1F66EC1, 0x446C5044, 0x5D32DE5D, 0x72466872
    dd        0x26A06526, 0x93CDBC93, 0x03DADB03, 0xC6BAF8C6
    dd        0xFA9EC8FA, 0x82D6A882, 0xCF6E2BCF, 0x50704050
    dd        0xEB85DCEB, 0x750AFE75, 0x8A93328A, 0x8DDFA48D
    dd        0x4C29CA4C, 0x141C1014, 0x73D72173, 0xCCB4F0CC
    dd        0x09D4D309, 0x108A5D10, 0xE2510FE2, 0x00000000
    dd        0x9A196F9A, 0xE01A9DE0, 0x8F94368F, 0xE6C742E6
    dd        0xECC94AEC, 0xFDD25EFD, 0xAB7FC1AB, 0xD8A8E0D8