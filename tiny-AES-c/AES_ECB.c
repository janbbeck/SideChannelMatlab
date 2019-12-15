#include <stdio.h>
#include <string.h>
#include <stdint.h>

// Enable ECB mode
#define ECB 1

#include "aes.h"

unsigned char data[16];

// prints string as hex
static void phex(uint8_t* str)
{
  uint8_t len = 16;
  unsigned char i;
  for (i = 0; i < len; ++i)
    printf("%.2x", str[i]);
  printf("\n");
}


void  main(int argc, char *argv[])
{
  if (17 == argc)    // 128bit data from input as space separated hex values like: ./aes-128-ecb.elf b0 b1 b2 b3 b4 b5 b6 b7 b8 b9 ba bb bc bd be bf
  {
    for (int i = 0; i < 16; i++)
    {
      sscanf(argv[i + 1], "%x", &data[i]);
    }
  }
  else
  {
    printf("Bad input, using default data\n");
    for (int i = 0; i < 16; i++)
    {
      data[i] = (unsigned char) i;
    }
  }
  // make sure the library is configured for AES128
#if defined(AES128)
  printf("\nTesting AES128\n\n");
#else
  printf("You need to specify AES128. Exiting");
  return 0;
#endif

  // Example of more verbose verification
  uint8_t i;
  uint8_t key[16] = { (uint8_t) 0x00, (uint8_t) 0x11, (uint8_t) 0x22, (uint8_t) 0x33, (uint8_t) 0x44, (uint8_t) 0x55, (uint8_t) 0x66, (uint8_t) 0x77, (uint8_t) 0x88, (uint8_t) 0x99, (uint8_t) 0xaa, (uint8_t) 0xbb, (uint8_t) 0xcc, (uint8_t) 0xdd, (uint8_t) 0xee, (uint8_t) 0xff };
  // print text to encrypt, key and IV
  printf("ECB encrypt verbose:\n\n");
  printf("plain text:\n");
  for (i = (uint8_t) 0; i < (uint8_t) 1; ++i)
  {
    phex(data + i * (uint8_t) 16);
  }
  printf("\n");

  // print the resulting cipher as 1 x 16 byte strings
  printf("ciphertext:\n");

  struct AES_ctx ctx;
  AES_init_ctx(&ctx, key);

  for (i = 0; i < 1; ++i)
  {
    AES_ECB_encrypt(&ctx, data + (i * 16));
    phex(data + (i * 16));
  }
  printf("\n");
  return;
}






