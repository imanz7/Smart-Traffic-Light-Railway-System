;
; fullproject.asm
;
.ORG 0x0000              
RJMP Reset              
.ORG 0x0020              
RJMP TIMER_OVF   

 Reset: 
 LDI	R16, 0b00000101			// set clock
 OUT	TCCR0B, R16      
 LDI	R16, 0b00000001			// enable overflow interrupt
 STS	TIMSK0, R16      
 SEI							// enable global interrupt
 CLR	R16
 OUT	TCNT0, R16      

 main:
 LDI    R16, 0b01001000               
 OUT    DDRD, R16               // set output for LEDs
 LDI	r16, 0xFE
 OUT	DDRC, R16				// set input for adc
 CALL	USART_init
 CALL	ADC_init
 CALL	ADC_read
 CALL	ADC_wait
 LDS	R30, ADCL
 LDS	R31, ADCH
 CALL	subl
 CALL	USART_tx
 RJMP	main

 ADC_init:
 LDI	R18, (1<<ADEN|1<<ADPS2|1<<ADPS1|1<<ADPS0|1<<ADATE|1<<ADSC)	// enable adc, 128 division factor
 STS	ADCSRA, R18
 LDI	R17, (0<<REFS1|1<<REFS0)									// voltage reference
 STS	ADMUX, R17 
 LDI	R17, (0<<ADTS2|0<<ADTS1|0<<ADTS0)
 STS	ADCSRB, R17
 RET

 USART_init:
 LDI	R17, 103
 STS	UBRR0L, R17								// set baud rate (19200)
 LDI	R17, (1<<RXEN0|1<<TXEN0)				// enable receive and transmit
 STS	UCSR0B, R17
 LDI	R17, (1<<USBS0|3<<UCSZ00)				// frame format: 8bit, 2 stop bits, sync
 STS	UCSR0C, R17
 RET
 
 ADC_read:
 LDI	R17, (1<<ADSC)							// conversion start
 STS	ADCSRA, R17
 OR		R17, R18
 STS	ADCSRA, R17
 RET

ADC_wait:
 LDS	R17, ADCSRA
 SBRS	R17, 4
 JMP	ADC_wait
 LDI	R16, 0b00010000
 LDS	R17, ADCSRA
 OR		R17, R16
 STS	ADCSRA, R17
 RET

 USART_tx:
 LDS	R17, UCSR0A
 SBRS	R17, UDRE0
 RJMP	USART_tx
 STS	UDR0, R26				// put data into buffer and send
 RET

 subl:
 LDI	R21, 0x02				// 0x200 = 512
 LDI	R20, 0x00
 CP		R30, R20				// compare lower bytes
 CPC	R31, R21				// compare higher bytes
 BRLO	LED_BLUE
 
 LED_GREEN:
 SBI    PortD, 6				// turn on green LED
 NOP
 call	timer
 CBI	PortD, 6				// turn off green LED
 NOP
 call	timer
 LDI	R26, $48				// store H
 RET
 
 LED_BLUE:
 SBI	PortD, 3				// turn on blue LED
 NOP
 call	timer
 CBI	PortD, 3				// turn off blue LED
 NOP
 call	timer
 LDI	R26, $4C				// store L
 RET

 timer:
 INC	R24
 delay: 
 CPI	R24, 30
 BRNE	delay
 RET

 TIMER_OVF:
 INC	R24         
 CPI	R24, 61    
 BRNE	PC+2            
 CLR	R24         
 RETI              