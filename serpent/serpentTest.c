#include <stdio.h>

extern void serpentEncrypt(char *, char *);
extern void serpentDecrypt(char *, char *);
extern void serpentGenKeyAsm(unsigned int *, unsigned int *);


int main()
{
	int i = 0;
	
	unsigned int data[4];
	unsigned int key[8];
	unsigned int expandedKey[132];
	
	//Read in user data and key
	printf("KY = ");
	scanf("%8x%8x%8x%8x%8x%8x%8x%8x",(key+7),(key+6) , (key+5), (key+4), (key+3),(key+2) , (key+1), (key+0));
	printf("PT = ");
	scanf("%8x%8x%8x%8x", data, (data+1), (data+2), (data+3));

	
	//Generate expanded encryption/decryption key
	serpentGenKeyAsm(key, expandedKey);
	
	
	
	//MONTE CARLO ENCRYPTION TEST
	
	//Encrypt data 10,000 times
	for(i = 0; i < 10000; i++)
	{
		serpentEncrypt(( char *)data,(char *) expandedKey);
	}
	
	//Display output
	printf("CT = ");
	for(i = 0; i < 4; i++)
	{
	    printf("%.8X", data[i]);
	}
	printf("\n");
	

	
	//MONTE CARLO DECRYPTION TEST
		
	//Decrypt data 10,000 times
	for(i = 0; i < 10000; i++)
	{
		serpentDecrypt(( char *)data,(char *) expandedKey);
	}

	//Display output
	printf("PT = ");
	for(i = 0; i < 4; i++)
	{
	    printf("%.8X", data[i]);
	}
	printf("\n");
	
	
	return 0;
}
