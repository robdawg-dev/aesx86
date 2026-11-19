/***********************************************************
This assembly implementation of Rijndael expects data
to be interpreted as a stream of bytes, not a stream
of 32-bit integers. When an integer is read in, the
bytes are "swapped" since Intel chips are little-endian.
For testing purposes only, I used scanf to read the data
in as four 32-bit integers. I then use swapBytes to convert
the data to be interpreted properly so that the known value
tests will yield the same answer. When using the assembly
in another program, you do not have to worry about swapping
the bytes. You only have to make sure that the data is read
in consistantly when reading data to be encrypted and when
reading data to be decrypted. If you don't swap the bytes,
you will get a different encryption value but if you then
decrypt it, you will get your original plaintext. The only
time you would need to be careful about interpreting byte 
order would be if you are going to be putting data out in a
standard way for another program, possibly not using the
supplied assembly, to be able to decrypt it.
***********************************************************/

#include <stdio.h>

extern void rijndaelEncrypt(char *, unsigned long *);
extern void rijndaelDecrypt(char *, unsigned long *);
extern void rijndaelGenEncryptKeyAsm(unsigned int *, unsigned int *);
extern void rijndaelGenDecryptKeyAsm(unsigned int *, unsigned int *);

void swapBytes(unsigned char* test, int numBytes)
{
    char a;
    char b;
    char c;
    char d;

    int i;


    for(i=0; i < numBytes; i++)
	{
	a = *test;
	b = *(test+1);
	c = *(test+2);
	d = *(test+3);
	*test = d;
	*(test+1) = c;
	*(test+2) = b;
	*(test+3) = a;
	test += 4;
	}
	
	return;
}


int main()
{
	int i = 0;
	
	unsigned int data[4];
	unsigned int key[8];
	unsigned long expandedKey[4 *(14 + 1)];
	unsigned char * pntrData = (unsigned char *) data;
	
	//Read in user data and key
	printf("KY = ");
	scanf("%8x%8x%8x%8x%8x%8x%8x%8x", key, (key+1), (key+2), (key+3), (key+4), (key+5), (key+6), (key+7)); 
	printf("PT = ");
	scanf("%8x%8x%8x%8x", data, (data+1), (data+2), (data+3));
	
	//Swap bytes to be big-endian
	swapBytes((unsigned char *) data, 4);
	swapBytes((unsigned char *) key, 8);
	
	
	
	//MONTE CARLO ENCRYPTION TEST
	
	//Generate expanded encryption key
	rijndaelGenEncryptKeyAsm(key , (unsigned int*) expandedKey);
	
	//Encrypt data 10,000 times
	for(i = 0; i < 10000; i++)
	{
	    rijndaelEncrypt((char *) data, expandedKey);
	}

	//Display output
	printf("CT = ");
	for(i = 0; i < 16; i++)
	{
	    printf("%.2X", pntrData[i]);
	}
	printf("\n");
	
	
	
	//MONTE CARLO DECRYPTION TEST

	//Generate expanded decryption key
	rijndaelGenDecryptKeyAsm(key, (unsigned int*) expandedKey);
	
	//Decrypt data 10,000 times
	for(i = 0; i < 10000; i++)
	{
	    rijndaelDecrypt((char *) data, expandedKey);
	}
	
	//Display output
	printf("PT = ");
	for(i = 0; i < 16; i++)
	{
	    printf("%.2X", pntrData[i]);
	}
	printf("\n");
	
	return 0;
}
