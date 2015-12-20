#!/bin/sh

PRINTER="Simulated Color Laser @ MBA"
DATAPATH="/Users/matsunag/Documents/aapautoprint/data"

SIZE=(A4 A3 LTR 11x17 LGL B5 A5)


#osascript ./airprint.scpt "A4_P_staple1_punchON" "${DATAPATH}/s_A4_P_1p.pdf" "${PRINTER}" "A4" "P" "1 箇所" "ON"
#osascript ./airprint.scpt "A4_P_staple2_punchON" "${DATAPATH}/s_A4_P_1p.pdf" "${PRINTER}" "A4" "P" "2 箇所" "ON"
#osascript ./airprint.scpt "A4_L_staple1_punchON" "${DATAPATH}/s_A4_L_1p.pdf" "${PRINTER}" "A4" "L" "1 箇所" "ON"
#osascript ./airprint.scpt "A4_L_staple2_punchON" "${DATAPATH}/s_A4_L_1p.pdf" "${PRINTER}" "A4" "L" "2 箇所" "ON"


#osascript ./airprint.scpt "A3_P_staple1_punchON" "${DATAPATH}/s_A3_P_1p.pdf" "${PRINTER}" "A3" "P" "1 箇所" "ON"
#osascript ./airprint.scpt "A3_P_staple2_punchON" "${DATAPATH}/s_A3_P_1p.pdf" "${PRINTER}" "A3" "P" "2 箇所" "ON"
#osascript ./airprint.scpt "A3_L_staple1_punchON" "${DATAPATH}/s_A3_L_1p.pdf" "${PRINTER}" "A3" "L" "1 箇所" "ON"
#osascript ./airprint.scpt "A3_L_staple2_punchON" "${DATAPATH}/s_A3_L_1p.pdf" "${PRINTER}" "A3" "L" "2 箇所" "ON"


osascript ./airprint.scpt "A5_P_staple1_punchON" "${DATAPATH}/s_A5_P_1p.pdf" "${PRINTER}" "A5" "P" "1 箇所" "ON"
osascript ./airprint.scpt "A5_P_staple2_punchON" "${DATAPATH}/s_A5_P_1p.pdf" "${PRINTER}" "A5" "P" "2 箇所" "ON"
osascript ./airprint.scpt "A5_L_staple1_punchON" "${DATAPATH}/s_A5_L_1p.pdf" "${PRINTER}" "A5" "L" "1 箇所" "ON"
osascript ./airprint.scpt "A5_L_staple2_punchON" "${DATAPATH}/s_A5_L_1p.pdf" "${PRINTER}" "A5" "L" "2 箇所" "ON"

