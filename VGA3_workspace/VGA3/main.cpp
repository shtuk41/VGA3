#include "xparameters.h"
#include "xil_printf.h"
#include "xgpio.h"
#include "xbram.h"
#include "xil_types.h"
#include "sleep.h"

// Get device IDs from xparameters.h
#define BTN_ID XPAR_AXI_GPIO_BUTTONS_DEVICE_ID
#define LED_ID XPAR_AXI_GPIO_LED_DEVICE_ID
#define BTN_CHANNEL 1
#define LED_CHANNEL 1
#define BTN_MASK 0b1111
#define LED_MASK 0b1111

int main() {
	XGpio_Config *cfg_ptr;
	//XGpio led_device;
	XGpio btn_device;
	XBram Bram;	/* The Instance of the BRAM Driver */
	u32 data;

	xil_printf("Entered function main\r\n");

	// Initialize LED Device
	//cfg_ptr = XGpio_LookupConfig(LED_ID);
	//XGpio_CfgInitialize(&led_device, cfg_ptr, cfg_ptr->BaseAddress);

	// Initialize Button Device
	cfg_ptr = XGpio_LookupConfig(BTN_ID);
	XGpio_CfgInitialize(&btn_device, cfg_ptr, cfg_ptr->BaseAddress);

	// Set Button Tristate
	XGpio_SetDataDirection(&btn_device, BTN_CHANNEL, BTN_MASK);

	// Set Led Tristate
	//XGpio_SetDataDirection(&led_device, LED_CHANNEL, 0);

	XBram_Config *ConfigPtr;
	ConfigPtr = XBram_LookupConfig(XPAR_BRAM_0_DEVICE_ID);

	if (ConfigPtr == (XBram_Config *) NULL)
	{
		xil_printf("BRAM lookup failed\r\n");
		return XST_FAILURE;
	}
	else
	{
		xil_printf("BRAM lookup succeeded\r\n");
	}

	int Status = XBram_CfgInitialize(&Bram, ConfigPtr, ConfigPtr->CtrlBaseAddress);
	if (Status != XST_SUCCESS)
	{
		xil_printf("BRAM CfgInitializze failed\r\n");
		return XST_FAILURE;
	}
	else
	{
		xil_printf("BRAM CfgInitializze succeeded\r\n");
	}

	Status = XBram_SelfTest(&Bram, 0);
	if (Status != XST_SUCCESS)
	{
		xil_printf("BRAM selftest failed\r\n");
		return XST_FAILURE;
	}
	else
	{
		xil_printf("BRAM selftest succeeded\r\n");
	}

	int out_data;

	int ii = 0;

	/*int pixelsNum = 60;

	for (int ii = 0; ii < pixelsNum; ii+=4)
	{
		XBram_WriteReg(XPAR_BRAM_0_DEVICE_ID, ii,ii);
		xil_printf("%d \r\n", ii);
	}


	for (int ii = 0; ii < pixelsNum; ii+=4)
	{
		out_data = XBram_ReadReg(XPAR_BRAM_0_DEVICE_ID, ii);
		xil_printf("%d: %d\r\n", ii, out_data);
	}*/

	out_data = XBram_ReadReg(XPAR_BRAM_0_DEVICE_ID, 0);
	xil_printf("%d \r\n", out_data);

	u32 data_prev;

	while (1)
	{

		data = XGpio_DiscreteRead(&btn_device, BTN_CHANNEL);
		data &= BTN_MASK;

		if (data == 0x1 && data != data_prev)
		{
			out_data = XBram_ReadReg(XPAR_BRAM_0_DEVICE_ID, 0);
			xil_printf("%d \r\n", out_data);
		}
		else if (data == 0x2 && data != data_prev)
		{
			if (ii == 0 || ii == 1)
			{
				ii+=1;
			}
			else
			{
				ii=0;
			}

			XBram_WriteReg(XPAR_BRAM_0_DEVICE_ID, 0,ii);
		}

		data_prev = data;
	}
}
