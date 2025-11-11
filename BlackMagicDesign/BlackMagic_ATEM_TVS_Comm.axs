MODULE_NAME="BlackMagic_ATEM_TVS_Comm" (DEV vdvDev,DEV dvDev[])
#INCLUDE "SNAPI"

//-----------------------------------------------------------------------------

DEFINE_CONSTANT
	Client = 1		// to send UDP packets
	Server = 2		// to receive UDP packets
	
	ProgramSource = 1
	PreviewSource = 2
	
	CameraSource = 1
	ColorSource = 2
	MediaSource = 3

DEFINE_VARIABLE
	VOLATILE INTEGER nDebugLevel
	VOLATILE INTEGER nClientOnline
	VOLATILE INTEGER nUIDAcquired
	VOLATILE CHAR cSwitchBuf[4096]
	
	VOLATILE CHAR cUID[2]
	VOLATILE INTEGER nPacketCounter
	VOLATILE CHAR cIPAddress[15]
	
	VOLATILE INTEGER nTempSource
	VOLATILE INTEGER nComm
	
DEFINE_VARIABLE
	VOLATILE CHAR cInitString[] = { $10,$14,$1B,$AA,$00,$00,$00,$00,$00,$1A,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00 }
	
//-----------------------------------------------------------------------------

DEFINE_FUNCTION DebugString(INTEGER nLevel,CHAR cString[]) {
	IF(nLevel<=nDebugLevel)
		SEND_STRING 0,""BlackMagic ATEM Comm: ",cString"
}

DEFINE_FUNCTION SocketOpen() {
	IP_CLIENT_OPEN(dvDev[Client].Port,cIPAddress,9910,IP_UDP_2WAY)
	IP_SERVER_OPEN(dvDev[Server].Port,9910,IP_UDP)
}
DEFINE_FUNCTION SocketClose() {
	CANCEL_WAIT "CommWait"
	OFF[nComm]
	IP_CLIENT_CLOSE(dvDev[Client].PORT)
	IP_SERVER_CLOSE(dvDev[Server].Port)
}

DEFINE_FUNCTION Switching(INTEGER nLevel,INTEGER nSourceType,INTEGER nSource) {
	SELECT {
		// Program Sources
		// cameras
		ACTIVE ((nLevel==ProgramSource) && (nSourceType==CameraSource)) : {
			nPacketCounter++
			SEND_STRING dvDev[Client],"$08,$18,cUID,$00,$00,$00,$00,$00,$00,$00,nPacketCounter,$00,$0c,$DD,$1A,$43,$50,$67,$49,$00,nSource,$00,$80"
		}
		// media 1
		ACTIVE ((nLevel==ProgramSource) && (nSourceType==MediaSource) && (nSource==1))	: {
			nPacketCounter++
			SEND_STRING dvDev[Client],"$08,$18,cUID,$00,$00,$00,$00,$00,$00,$00,nPacketCounter,$00,$0c,$5f,$1b,$43,$50,$67,$49,$00,$0a,$00,$80"
		}
		// media 2
		ACTIVE ((nLevel==ProgramSource) && (nSourceType==MediaSource) && (nSource==2))	: {
			nPacketCounter++
			SEND_STRING dvDev[Client],"$08,$18,cUID,$00,$00,$00,$00,$00,$00,$00,nPacketCounter,$00,$0c,$5f,$1b,$43,$50,$67,$49,$00,$0c,$00,$80"
		}
		// color 1
		ACTIVE ((nLevel==ProgramSource) && (nSourceType==ColorSource) && (nSource==1))	: {
			nPacketCounter++
			SEND_STRING dvDev[Client],"$08,$18,cUID,$00,$00,$00,$00,$00,$00,$00,nPacketCounter,$00,$0c,$5f,$1b,$43,$50,$67,$49,$00,$08,$00,$80"
		}
		// color 2
		ACTIVE ((nLevel==ProgramSource) && (nSourceType==ColorSource) && (nSource==2))	: {
			nPacketCounter++
			SEND_STRING dvDev[Client],"$08,$18,cUID,$00,$00,$00,$00,$00,$00,$00,nPacketCounter,$00,$0c,$5f,$1b,$43,$50,$67,$49,$00,$09,$00,$80"
		}
		// black
		ACTIVE ((nLevel==ProgramSource) && (nSourceType==ColorSource) && (nSource==3))	: {
			nPacketCounter++
			SEND_STRING dvDev[Client],"$08,$18,cUID,$00,$00,$00,$00,$00,$00,$00,nPacketCounter,$00,$0c,$dd,$1a,$43,$50,$67,$49,$00,$00,$00,$80"
		}
		// bars
		ACTIVE ((nLevel==ProgramSource) && (nSourceType==ColorSource) && (nSource==4))	: {
			nPacketCounter++
			SEND_STRING dvDev[Client],"$08,$18,cUID,$00,$00,$00,$00,$00,$00,$00,nPacketCounter,$00,$0c,$ec,$1a,$43,$50,$67,$49,$00,$07,$00,$80"
		}
		
		// Preview Sources
		//cameras
		ACTIVE ((nLevel==PreviewSource) && (nSourceType==CameraSource)) : {
			nPacketCounter++
			SEND_STRING dvDev[Client],"$08,$18,cUID,$00,$00,$00,$00,$00,$00,$00,nPacketCounter,$00,$0c,$3e,$74,$43,$50,$76,$49,$00,nSource,$c0,$d5"
		}
		//media 1
		ACTIVE ((nLevel==PreviewSource) && (nSourceType==MediaSource) && (nSource==1)) : {
			nPacketCounter++
			SEND_STRING dvDev[Client],"$08,$18,cUID,$00,$00,$00,$00,$00,$00,$00,nPacketCounter,$00,$0c,$ec,$1a,$43,$50,$76,$49,$00,$0a,$00,$80"
		}
		// media 2
		ACTIVE ((nLevel==PreviewSource) && (nSourceType==MediaSource) && (nSource==2)) : {
			nPacketCounter++
			SEND_STRING dvDev[Client],"$08,$18,cUID,$00,$00,$00,$00,$00,$00,$00,nPacketCounter,$00,$0c,$ec,$1a,$43,$50,$76,$49,$00,$0c,$00,$80"
		}
		//color 1
		ACTIVE ((nLevel==PreviewSource) && (nSourceType==ColorSource) && (nSource==1)) : {
			nPacketCounter++
			SEND_STRING dvDev[Client],"$08,$18,cUID,$00,$00,$00,$00,$00,$00,$00,nPacketCounter,$00,$0c,$ec,$1a,$43,$50,$76,$49,$00,$08,$00,$80"
		}
		//color 2
		ACTIVE ((nLevel==PreviewSource) && (nSourceType==ColorSource) && (nSource==2)) : {
			nPacketCounter++
			SEND_STRING dvDev[Client],"$08,$18,cUID,$00,$00,$00,$00,$00,$00,$00,nPacketCounter,$00,$0c,$ec,$1a,$43,$50,$76,$49,$00,$09,$00,$80"
		}
		// black
		ACTIVE ((nLevel==PreviewSource) && (nSourceType==ColorSource) && (nSource==3))	: {
			nPacketCounter++
			SEND_STRING dvDev[Client],"$08,$18,cUID,$00,$00,$00,$00,$00,$00,$00,nPacketCounter,$00,$0c,$dd,$1a,$43,$50,$76,$49,$00,$00,$00,$80"
		}
		// bars
		ACTIVE ((nLevel==PreviewSource) && (nSourceType==ColorSource) && (nSource==4))	: {
			nPacketCounter++
			SEND_STRING dvDev[Client],"$08,$18,cUID,$00,$00,$00,$00,$00,$00,$00,nPacketCounter,$00,$0c,$ec,$1a,$43,$50,$76,$49,$00,$07,$00,$80"
		}
		
		
		ACTIVE (1) : DebugString(1,""ERROR - Unhandled Switch Parameters @ Subroutine "Switching""")
	}
}

DEFINE_FUNCTION SwitchSelect(INTEGER nLevel,INTEGER nSource) {
	DebugString(3,""SwitchSelect(",ITOA(nLevel),",",ITOA(nSource),")"")
	nPacketCounter++
	SELECT {
		// cameras
		//ACTIVE ((nLevel==ProgramSource) && (nSource>=1) && (nSource<=6)) : SEND_STRING dvDev[Client],"$08,$18,cUID,$00,$00,$00,$00,$00,$00,$00,nPacketCounter,$00,$0c,$DD,$1A,$43,$50,$67,$49,$00,nSource,$00,$80"
		ACTIVE ((nLevel==ProgramSource) && (nSource>=1) && (nSource<=6)) : SEND_STRING dvDev[Client],"$08,$18,cUID,$00,$00,$00,$00,$00,$00,$00,nPacketCounter,$00,$0c,$9A,$1B,$43,$50,$67,$49,$00,$00,$00,nSource"
		
		// colors 1,2,black,bars
		ACTIVE ((nLevel==ProgramSource) && (nSource==7)) 	: SEND_STRING dvDev[Client],"$08,$18,cUID,$00,$00,$00,$00,$00,$00,$00,nPacketCounter,$00,$0c,$5f,$1b,$43,$50,$67,$49,$00,$08,$00,$80"
		ACTIVE ((nLevel==ProgramSource) && (nSource==8)) : SEND_STRING dvDev[Client],"$08,$18,cUID,$00,$00,$00,$00,$00,$00,$00,nPacketCounter,$00,$0c,$5f,$1b,$43,$50,$67,$49,$00,$09,$00,$80"
		ACTIVE ((nLevel==ProgramSource) && (nSource==9)) : SEND_STRING dvDev[Client],"$08,$18,cUID,$00,$00,$00,$00,$00,$00,$00,nPacketCounter,$00,$0c,$dd,$1a,$43,$50,$67,$49,$00,$00,$00,$80"
		ACTIVE ((nLevel==ProgramSource) && (nSource==10)) : SEND_STRING dvDev[Client],"$08,$18,cUID,$00,$00,$00,$00,$00,$00,$00,nPacketCounter,$00,$0c,$ec,$1a,$43,$50,$67,$49,$00,$07,$00,$80"
		// media 1 & 2
		ACTIVE ((nLevel==ProgramSource) && (nSource==11)) 	: SEND_STRING dvDev[Client],"$08,$18,cUID,$00,$00,$00,$00,$00,$00,$00,nPacketCounter,$00,$0c,$5f,$1b,$43,$50,$67,$49,$00,$0a,$00,$80"
		ACTIVE ((nLevel==ProgramSource) && (nSource==12)) 	: SEND_STRING dvDev[Client],"$08,$18,cUID,$00,$00,$00,$00,$00,$00,$00,nPacketCounter,$00,$0c,$5f,$1b,$43,$50,$67,$49,$00,$0c,$00,$80"
		
		// cameras
		//ACTIVE ((nLevel==PreviewSource) && (nSource>=1) && (nSource<=6)) : SEND_STRING dvDev[Client],"$08,$18,cUID,$00,$00,$00,$00,$00,$00,$00,nPacketCounter,$00,$0c,$3e,$74,$43,$50,$76,$49,$00,nSource,$c0,$d5"
		ACTIVE ((nLevel==PreviewSource) && (nSource>=1) && (nSource<=6)) : SEND_STRING dvDev[Client],"$08,$18,cUID,$00,$00,$00,$00,$00,$00,$00,nPacketCounter,$00,$0c,$99,$1B,$43,$50,$76,$49,$00,$00,$00,nSource"
		// colors 1,2,black,bars
		ACTIVE ((nLevel==PreviewSource) && (nSource==7)) 	: SEND_STRING dvDev[Client],"$08,$18,cUID,$00,$00,$00,$00,$00,$00,$00,nPacketCounter,$00,$0c,$ec,$1a,$43,$50,$76,$49,$00,$08,$00,$80"
		ACTIVE ((nLevel==PreviewSource) && (nSource==8)) : SEND_STRING dvDev[Client],"$08,$18,cUID,$00,$00,$00,$00,$00,$00,$00,nPacketCounter,$00,$0c,$ec,$1a,$43,$50,$76,$49,$00,$09,$00,$80"
		ACTIVE ((nLevel==PreviewSource) && (nSource==9)) : SEND_STRING dvDev[Client],"$08,$18,cUID,$00,$00,$00,$00,$00,$00,$00,nPacketCounter,$00,$0c,$dd,$1a,$43,$50,$76,$49,$00,$00,$00,$80"
		ACTIVE ((nLevel==PreviewSource) && (nSource==10)) : SEND_STRING dvDev[Client],"$08,$18,cUID,$00,$00,$00,$00,$00,$00,$00,nPacketCounter,$00,$0c,$ec,$1a,$43,$50,$76,$49,$00,$07,$00,$80"
		// media 1 & 2
		ACTIVE ((nLevel==PreviewSource) && (nSource==11)) 	: SEND_STRING dvDev[Client],"$08,$18,cUID,$00,$00,$00,$00,$00,$00,$00,nPacketCounter,$00,$0c,$ec,$1a,$43,$50,$76,$49,$00,$0a,$00,$80"
		ACTIVE ((nLevel==PreviewSource) && (nSource==12)) 	: SEND_STRING dvDev[Client],"$08,$18,cUID,$00,$00,$00,$00,$00,$00,$00,nPacketCounter,$00,$0c,$ec,$1a,$43,$50,$76,$49,$00,$0c,$00,$80"
	}                                              
}

//-----------------------------------------------------------------------------

DEFINE_EVENT		// Nothing to see here
	DATA_EVENT [dvDev[Server]] {
		ONLINE : {
			DebugString(2,""*** Server Socket ONLINE ***"")
		}
		OFFLINE : {
			DebugString(2,""*** Server Socket OFFLINE ***"")
		}
	}
	
DEFINE_EVENT		// This is where the magic happens
	DATA_EVENT [dvDev[Client]] {
		ONLINE : {
			DebugString(2,""*** Client Socket ONLINE ***"")
			nPacketCounter = 0
			ON[nClientOnline]
			
			WAIT 5
				SEND_STRING dvDev[Client],"cInitString"
		}
		ONERROR : {
			DebugString(1,""*** Client Socket ERROR ***"")
			SELECT {
				ACTIVE (DATA.NUMBER == 2) : DebugString(1,""ERROR - Socket Open: General Failure (out of memory)"")
				ACTIVE (DATA.NUMBER == 4) : DebugString(1,""ERROR - Socket Open: Unknown Host"")				
				ACTIVE (DATA.NUMBER == 6) : DebugString(1,""ERROR - Socket Open: Connection Refused"")
				ACTIVE (DATA.NUMBER == 8) : DebugString(1,""ERROR - Socket Open: Unknown Connection Error"")
				ACTIVE (DATA.NUMBER == 9) : DebugString(1,""ERROR - Socket Open: Already closed"")
				ACTIVE (DATA.NUMBER == 14) : DebugString(1,""ERROR - Socket Open: Local Port already in use"")
				ACTIVE (DATA.NUMBER == 16) : DebugString(1,""ERROR - Socket Open: Too many open sockets"")
				ACTIVE (DATA.NUMBER == 17) : DebugString(1,""ERROR - Socket Open: Local port not open"")
			}
		}
		OFFLINE : {
			DebugString(2,""*** Client Socket OFFLINE ***"")
			OFF[nClientOnline]
			OFF[nUIDAcquired]
			nPacketCounter = 0
		}
		STRING : {
			STACK_VAR CHAR cRxHeader[2]
			STACK_VAR CHAR cPingID[2]
			DebugString(4,""*** Client Socket RX: cSwitchBuf Length: ",ITOA(LENGTH_STRING(cSwitchBuf))," ***"")
			
			SELECT {
				ACTIVE (LEFT_STRING(cSwitchBuf,13)=="$10,$14,$1B,$AA,$00,$00,$00,$00,$00,$31,$00,$00,$02") : {
					SEND_STRING dvDev[Client],"$80,$0C,$1B,$AA,$00,$00,$00,$00,$00,$27,$00,$00"
					
					ON[nComm]
					WAIT 20 "CommWait"
						OFF[nComm]
				}
				
				// secondary communication init response to switcher
				ACTIVE (LEFT_STRING(cSwitchBuf,13)=="$30,$14,$00,$8e,$00,$00,$00,$00,$00,$31,$00,$00,$02") : {
					SEND_STRING dvDev[Client],"$80,$0c,$1B,$AA,$00,$00,$00,$00,$00,$99,$00,$00"
					DebugString(4,""Sending secondary init ack"")
					
					ON[nComm]
					WAIT 20 "CommWait"
						OFF[nComm]
				}
				
				// first appearance of switcher-provided UID
				ACTIVE (FIND_STRING(cSwitchBuf,"$0D,$6C",1)) : {
					ON[nUIDAcquired]
					cUID = MID_STRING(cSwitchBuf,3,2)
					DebugString(3,""Device UID = ",cUID")
				}
				
				// ping from device
				ACTIVE (FIND_STRING(cSwitchBuf,"$08,$0C,cUID",1)) : {
					DebugString(4,""Ping Received from Device, Send Pong"")
					cPingID = MID_STRING(cSwitchBuf,11,2)
					
					// pong
					SEND_STRING dvDev[Client],"$80,$0C,cUID,cPingID,$00,$00,$00,$00,$00,$00"
					
					CANCEL_WAIT "CommWait"
					WAIT 20 "CommWait"
						OFF[nComm]
				}
				
				// re-ping from device
				ACTIVE (FIND_STRING(cSwitchBuf,"$28,$0C,cUID",1)) : {
					DebugString(4,""Re Ping Received from Device, Send Pong"")
					cPingID = MID_STRING(cSwitchBuf,11,2)
					
					// pong
					SEND_STRING dvDev[Client],"$80,$0C,cUID,cPingID,$00,$00,$00,$00,$00,$00"
					
					CANCEL_WAIT "CommWait"
					WAIT 20 "CommWait"
						OFF[nComm]
				}
				
				ACTIVE (FIND_STRING (cSwitchBuf,"$08,$28,cUID",1)) : {
					DebugString(4,""Re Ping Received from Device, Send Pong"")
					cPingID = MID_STRING(cSwitchBuf,11,2)
					
					// pong
					SEND_STRING dvDev[Client],"$80,$0C,cUID,cPingID,$00,$00,$00,$00,$00,$00"
					
					CANCEL_WAIT "CommWait"
					WAIT 20 "CommWait"
						OFF[nComm]
						
					IF(FIND_STRING(cSwitchBuf,""TrSS"",1)) {
						REMOVE_STRING(cSwitchBuf,""TrSS"",1)
						SELECT {
							ACTIVE (LEFT_STRING(cSwitchBuf,8)=="$00,$00,$01,$00,$01,$06,$01,$00") : SEND_STRING vdvDev,""TRANSITION-MIX""
							ACTIVE (LEFT_STRING(cSwitchBuf,8)=="$00,$01,$01,$01,$01,$06,$01,$00") : SEND_STRING vdvDev,""TRANSITION-DIP""
							ACTIVE (LEFT_STRING(cSwitchBuf,8)=="$00,$02,$01,$02,$01,$06,$01,$00") : SEND_STRING vdvDev,""TRANSITION-WIPE""
						}
					}
				}
				
				ACTIVE (FIND_STRING (cSwitchBuf,"$88,$28,cUID",1)) : {
					DebugString(4,""Re Ping Received from Device, Send Pong"")
					cPingID = MID_STRING(cSwitchBuf,11,2)
					
					// pong
					SEND_STRING dvDev[Client],"$80,$0C,cUID,cPingID,$00,$00,$00,$00,$00,$00"
					
					CANCEL_WAIT "CommWait"
					WAIT 20 "CommWait"
						OFF[nComm]
						
					IF(FIND_STRING(cSwitchBuf,""TrSS"",1)) {
						REMOVE_STRING(cSwitchBuf,""TrSS"",1)
						SELECT {
							ACTIVE (LEFT_STRING(cSwitchBuf,8)=="$00,$00,$01,$00,$01,$06,$01,$00") : SEND_STRING vdvDev,""TRANSITION-MIX""
							ACTIVE (LEFT_STRING(cSwitchBuf,8)=="$00,$01,$01,$01,$01,$06,$01,$00") : SEND_STRING vdvDev,""TRANSITION-DIP""
							ACTIVE (LEFT_STRING(cSwitchBuf,8)=="$00,$02,$01,$02,$01,$06,$01,$00") : SEND_STRING vdvDev,""TRANSITION-WIPE""
						}
					}
				}
				
				
				// source feedback
				ACTIVE (FIND_STRING(cSwitchBuf,"PrgI",1) && FIND_STRING(cSwitchBuf,"PrvI",1)) : {
					REMOVE_STRING(cSwitchBuf,""PrgI",$00",1)
					nTempSource = TYPE_CAST(GET_BUFFER_STRING(cSwitchBuf,1))
					DebugString(2,""Program Source = ",ITOA(nTempSource)")
					
					SELECT {
						// cameras
						ACTIVE ((nTempSource>=1) && (nTempSource<=6)) : {
							SEND_STRING vdvDev,""SWITCH-PROGRAM,CAMERA,",ITOA(nTempSource)"
							SEND_STRING vdvDev,""SWITCHSELECT-PROGRAM,",ITOA(nTempSource)"
						}
						
						// media
						ACTIVE (nTempSource==10)	:	{
							SEND_STRING vdvDev,""SWITCH-PROGRAM,MEDIA,1""
							SEND_STRING vdvDev,""SWITCHSELECT-PROGRAM,7""
						}
						ACTIVE (nTempSource==12)	:	{
							SEND_STRING vdvDev,""SWITCH-PROGRAM,MEDIA,2""
							SEND_STRING vdvDev,""SWITCHSELECT-PROGRAM,8""
						}
						
						// colors
						ACTIVE (nTempSource==8)	:	{
							SEND_STRING vdvDev,""SWITCH-PROGRAM,COLOR,1""
							SEND_STRING vdvDev,""SWITCHSELECT-PROGRAM,9""
						}
						ACTIVE (nTempSource==9)	:	{
							SEND_STRING vdvDev,""SWITCH-PROGRAM,COLOR,2""
							SEND_STRING vdvDev,""SWITCHSELECT-PROGRAM,10""
						}
						ACTIVE (nTempSource==0)	:	{
							SEND_STRING vdvDev,""SWITCH-PROGRAM,COLOR,3""
							SEND_STRING vdvDev,""SWITCHSELECT-PROGRAM,11""
						}
						ACTIVE (nTempSource==7)	:	{
							SEND_STRING vdvDev,""SWITCH-PROGRAM,COLOR,4""
							SEND_STRING vdvDev,""SWITCHSELECT-PROGRAM,12""
						}
					}                                                                                    
					
					REMOVE_STRING(cSwitchBuf,""PrvI",$00",1)
					nTempSource = TYPE_CAST(GET_BUFFER_STRING(cSwitchBuf,1))
					DebugString(2,""Preview Source = ",ITOA(nTempSource)")
					
					SEND_STRING vdvDev,""SWITCHSELECT-PREVIEW,",ITOA(nTempSource)"
					
					SELECT {
						// cameras
						ACTIVE ((nTempSource>=1) && (nTempSource<=6)) : {
							SEND_STRING vdvDev,""SWITCH-PREVIEW,CAMERA,",ITOA(nTempSource)"
							SEND_STRING vdvDev,""SWITCHSELECT-PREVIEW,",ITOA(nTempSource)"
						}
						
						// media
						ACTIVE (nTempSource==10)	:	{
							SEND_STRING vdvDev,""SWITCH-PREVIEW,MEDIA,1""
							SEND_STRING vdvDev,""SWITCHSELECT-PREVIEW,7""
						}
						ACTIVE (nTempSource==12)	:	{
							SEND_STRING vdvDev,""SWITCH-PREVIEW,MEDIA,2""
							SEND_STRING vdvDev,""SWITCHSELECT-PREVIEW,8""
						}
						
						// colors
						ACTIVE (nTempSource==8)	:	{
							SEND_STRING vdvDev,""SWITCH-PREVIEW,COLOR,1""
							SEND_STRING vdvDev,""SWITCHSELECT-PREVIEW,9""
						}
						ACTIVE (nTempSource==9)	:	{
							SEND_STRING vdvDev,""SWITCH-PREVIEW,COLOR,2""
							SEND_STRING vdvDev,""SWITCHSELECT-PREVIEW,10""
						}
						ACTIVE (nTempSource==0)	:	{
							SEND_STRING vdvDev,""SWITCH-PREVIEW,COLOR,3""
							SEND_STRING vdvDev,""SWITCHSELECT-PREVIEW,11""
						}
						ACTIVE (nTempSource==7)	:	{
							SEND_STRING vdvDev,""SWITCH-PREVIEW,COLOR,4""
							SEND_STRING vdvDev,""SWITCHSELECT-PREVIEW,12""
						}
					}
				}
				
				// source feedback
				ACTIVE (FIND_STRING(cSwitchBuf,"PrgI",1)) : {
					REMOVE_STRING(cSwitchBuf,""PrgI",$00",1)
					nTempSource = TYPE_CAST(GET_BUFFER_STRING(cSwitchBuf,1))
					DebugString(2,""Program Source = ",ITOA(nTempSource)")
					
					SELECT {
						// cameras
						ACTIVE ((nTempSource>=1) && (nTempSource<=6)) : {
							SEND_STRING vdvDev,""SWITCH-PROGRAM,CAMERA,",ITOA(nTempSource)"
							SEND_STRING vdvDev,""SWITCHSELECT-PROGRAM,",ITOA(nTempSource)"
						}
						
						// media
						ACTIVE (nTempSource==10)	:	{
							SEND_STRING vdvDev,""SWITCH-PROGRAM,MEDIA,1""
							SEND_STRING vdvDev,""SWITCHSELECT-PROGRAM,7""
						}
						ACTIVE (nTempSource==12)	:	{
							SEND_STRING vdvDev,""SWITCH-PROGRAM,MEDIA,2""
							SEND_STRING vdvDev,""SWITCHSELECT-PROGRAM,8""
						}
						
						// colors
						ACTIVE (nTempSource==8)	:	{
							SEND_STRING vdvDev,""SWITCH-PROGRAM,COLOR,1""
							SEND_STRING vdvDev,""SWITCHSELECT-PROGRAM,9""
						}
						ACTIVE (nTempSource==9)	:	{
							SEND_STRING vdvDev,""SWITCH-PROGRAM,COLOR,2""
							SEND_STRING vdvDev,""SWITCHSELECT-PROGRAM,10""
						}
						ACTIVE (nTempSource==0)	:	{
							SEND_STRING vdvDev,""SWITCH-PROGRAM,COLOR,3""
							SEND_STRING vdvDev,""SWITCHSELECT-PROGRAM,11""
						}
						ACTIVE (nTempSource==7)	:	{
							SEND_STRING vdvDev,""SWITCH-PROGRAM,COLOR,4""
							SEND_STRING vdvDev,""SWITCHSELECT-PROGRAM,12""
						}
					}  
				}
				
				// source feedback
				ACTIVE (FIND_STRING(cSwitchBuf,"PrvI",1)) : {
					REMOVE_STRING(cSwitchBuf,""PrvI",$00",1)
					nTempSource = TYPE_CAST(GET_BUFFER_STRING(cSwitchBuf,1))
					DebugString(2,""Preview Source = ",ITOA(nTempSource)")
					
					SELECT {
						// cameras
						ACTIVE ((nTempSource>=1) && (nTempSource<=6)) : {
							SEND_STRING vdvDev,""SWITCH-PREVIEW,CAMERA,",ITOA(nTempSource)"
							SEND_STRING vdvDev,""SWITCHSELECT-PREVIEW,",ITOA(nTempSource)"
						}
						
						// media
						ACTIVE (nTempSource==10)	:	{
							SEND_STRING vdvDev,""SWITCH-PREVIEW,MEDIA,1""
							SEND_STRING vdvDev,""SWITCHSELECT-PREVIEW,7""
						}
						ACTIVE (nTempSource==12)	:	{
							SEND_STRING vdvDev,""SWITCH-PREVIEW,MEDIA,2""
							SEND_STRING vdvDev,""SWITCHSELECT-PREVIEW,8""
						}
						
						// colors
						ACTIVE (nTempSource==8)	:	{
							SEND_STRING vdvDev,""SWITCH-PREVIEW,COLOR,1""
							SEND_STRING vdvDev,""SWITCHSELECT-PREVIEW,9""
						}
						ACTIVE (nTempSource==9)	:	{
							SEND_STRING vdvDev,""SWITCH-PREVIEW,COLOR,2""
							SEND_STRING vdvDev,""SWITCHSELECT-PREVIEW,10""
						}
						ACTIVE (nTempSource==0)	:	{
							SEND_STRING vdvDev,""SWITCH-PREVIEW,COLOR,3""
							SEND_STRING vdvDev,""SWITCHSELECT-PREVIEW,11""
						}
						ACTIVE (nTempSource==7)	:	{
							SEND_STRING vdvDev,""SWITCH-PREVIEW,COLOR,4""
							SEND_STRING vdvDev,""SWITCHSELECT-PREVIEW,12""
						}
					}
				}
					
				ACTIVE (FIND_STRING(cSwitchBuf,""TrSS"",1)) : {
					REMOVE_STRING(cSwitchBuf,""TrSS"",1)
					SELECT {
						ACTIVE (LEFT_STRING(cSwitchBuf,8)=="$00,$00,$01,$00,$01,$06,$01,$00") : SEND_STRING vdvDev,""TRANSITION-MIX""
						ACTIVE (LEFT_STRING(cSwitchBuf,8)=="$00,$01,$01,$01,$01,$06,$01,$00") : SEND_STRING vdvDev,""TRANSITION-DIP""
						ACTIVE (LEFT_STRING(cSwitchBuf,8)=="$00,$02,$01,$02,$01,$06,$01,$00") : SEND_STRING vdvDev,""TRANSITION-WIPE""
					}
				}				
				
				ACTIVE (1) : {}
			}
			
			CLEAR_BUFFER cSwitchBuf
		}
	}
	
DEFINE_EVENT
	DATA_EVENT [vdvDev] {
		COMMAND : {
			STACK_VAR CHAR cCmd[32]
			STACK_VAR CHAR cPara[8][32]
			
			cCmd = DuetParseCmdHeader(DATA.TEXT)
			
			SELECT {
				
				ACTIVE (cCmd=="SWITCH") : {
					cPara[1] = DuetParseCmdParam(DATA.TEXT)
					
					SELECT {
						ACTIVE (cPara[1]=="PREVIEW") : {
							cPara[1] = DuetParseCmdParam(DATA.TEXT)
							
							SELECT {
								ACTIVE (cPara[1]=="CAMERA") : Switching(PreviewSource,CameraSource,ATOI(DuetParseCmdParam(DATA.TEXT)))
								ACTIVE (cPara[1]=="COLOR") : Switching(PreviewSource,ColorSource,ATOI(DuetParseCmdParam(DATA.TEXT)))
								ACTIVE (cPara[1]=="MEDIA") : Switching(PreviewSource,MediaSource,ATOI(DuetParseCmdParam(DATA.TEXT)))
								
								ACTIVE (1) : DebugString(1,""ERROR - Unhandled SWITCH : PREVIEW Parameter"")
							}
						}
						
						ACTIVE (cPara[1]=="PROGRAM") : {
							cPara[1] = DuetParseCmdParam(DATA.TEXT)
							
							SELECT {
								ACTIVE (cPara[1]=="CAMERA") : Switching(ProgramSource,CameraSource,ATOI(DuetParseCmdParam(DATA.TEXT)))
								ACTIVE (cPara[1]=="COLOR") : Switching(ProgramSource,ColorSource,ATOI(DuetParseCmdParam(DATA.TEXT)))
								ACTIVE (cPara[1]=="MEDIA") : Switching(ProgramSource,MediaSource,ATOI(DuetParseCmdParam(DATA.TEXT)))
								
								ACTIVE (1) : DebugString(1,""ERROR - Unhandled SWITCH : PREVIEW Parameter"")
							}
						}
						
						ACTIVE (1) : DebugString(1,""ERROR - Unhandled SWITCH Parameter"")
					}
				}
				
				ACTIVE (cCmd=="SWITCHSELECT") : {
					cPara[1] = DuetParseCmdParam(DATA.TEXT)
					
					SELECT {
						ACTIVE (cPara[1]=="PROGRAM") : SwitchSelect(ProgramSource,ATOI(DuetParseCmdParam(DATA.TEXT)))
						ACTIVE (cPara[1]=="PREVIEW") : SwitchSelect(PreviewSource,ATOI(DuetParseCmdParam(DATA.TEXT)))
						ACTIVE (1) : DebugString(1,""ERROR - Unhandled SWITCHSELECT parameter"")
					}
				}
				
				ACTIVE (cCmd=="CUT") : {
					nPacketCounter++
					SEND_STRING dvDev[Client],"$08,$18,cUID,$00,$00,$00,$00,$00,$00,$00,nPacketCounter,$00,$0c,$00,$00,$44,$43,$75,$74,$00,$cf,$ed,$01"
				}
				ACTIVE (cCmd=="TAKE") : {
					nPacketCounter++
					SEND_STRING dvDev[Client],"$08,$18,cUID,$00,$00,$00,$00,$00,$00,$00,nPacketCounter,$00,$0c,$00,$00,$44,$41,$75,$74,$00,$d4,$c7,$00"
					SEND_STRING dvDev[Client],"$08,$18,cUID,$00,$00,$00,$00,$00,$00,$00,nPacketCounter,$00,$0c,$00,$00,$44,$41,$75,$74,$00,$d4,$c7,$00"
				}
				
				ACTIVE (cCmd=="TRANSITION") : {
					cPara[1]=DuetParseCmdParam(DATA.TEXT)
					SELECT {
						ACTIVE (cPara[1]=="MIX") : {
							nPacketCounter++
							SEND_STRING dvDev[Client],"$08,$18,cUID,$00,$00,$00,$00,$00,$00,$00,nPacketCounter,$00,$0c,$a1,$06,$43,$54,$54,$70,$01,$00,$00,$5b"
						}
						ACTIVE (cPara[1]=="DIP") : {
							nPacketCounter++
							SEND_STRING dvDev[Client],"$08,$18,cUID,$00,$00,$00,$00,$00,$00,$00,nPacketCounter,$00,$0c,$7c,$0d,$43,$54,$54,$70,$01,$00,$01,$5b"
						}
						ACTIVE (cPara[1]=="WIPE") : {
							nPacketCounter++
							SEND_STRING dvDev[Client],"$08,$18,cUID,$00,$00,$00,$00,$00,$00,$00,nPacketCounter,$00,$0c,$a1,$06,$43,$54,$54,$70,$01,$00,$02,$5b"
						}
					}
				}
				
				
				ACTIVE (cCmd=="SOCKET") : {
					cPara[1] = DuetParseCmdParam(DATA.TEXT)
					SELECT {
						ACTIVE (cPara[1]=="OPEN") : SocketOpen()
						ACTIVE (cPara[1]=="CLOSE") : SocketClose()
						ACTIVE (1) : DebugString(1,""ERROR - Invalid SOCKET Parameter"")
					}
				}
				
				ACTIVE (cCmd=="INIT") : {
					SEND_STRING dvDev[Client],"cInitString"
				}
				
				ACTIVE (cCmd=="REINIT") : {
					SocketClose()
					WAIT 10 {
						SocketOpen()
					}
				}
				
				ACTIVE (cCmd=="PROPERTY") : {
					cPara[1] = DuetParseCmdParam(DATA.TEXT)
					SELECT {
						ACTIVE (cPara[1]=="IP_Address") : {
							cIPAddress = DuetParseCmdParam(DATA.TEXT)
							DebugString(3,""Property : IP Address = ",cIPAddress")
						}
						ACTIVE (1) : DebugString(1,""ERROR - Unhandled PROPERTY Parameter"")
					}
				}
				
				
				ACTIVE (cCmd=="DEBUG") : {
					nDebugLevel = ATOI(DuetParseCmdParam(DATA.TEXT))
					DebugString(nDebugLevel,""Debug Level = ",ITOA(nDebugLevel)")
				}
				
				
				ACTIVE (1) : DebugString(1,""ERROR - Unhandled command to virtual device"")
			}
		}
	}



//-----------------------------------------------------------------------------

DEFINE_START
	cIPAddress = "192.168.10.240"
	nDebugLevel = 1
	nPacketCounter = 0
	OFF[nUIDAcquired]
	
	CREATE_BUFFER dvDev[Client],cSwitchBuf
	
DEFINE_PROGRAM
	[vdvDev,252] = nComm