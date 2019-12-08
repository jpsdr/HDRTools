/*
 *  TransferFunctions
 *
 *  OOTF,EOTF,OETF, etc... HDR and SDR core functions.
 *  Copyright (C) 2019 JPSDR
 *	
 *  HDRTools is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2, or (at your option)
 *  any later version.
 *   
 *  HDRTools is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *  GNU General Public License for more details.
 *   
 *  You should have received a copy of the GNU General Public License
 *  along with GNU Make; see the file COPYING.  If not, write to
 *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA. 
 *
 */

void Set_l_HLG(double lw);
double HLG_OETF(double x);
double HLG_inv_OETF(double x);
double HLG_OOTF(double x);
double HLG_inv_OOTF(double x);
double inv_OETF(double x);
double OETF(double x);
double EOTF(double x);
double PQ_OOTF(double x);
double PQ_OOTF_Inv(double x);
double PQ_EOTF(double x);
double PQ_inv_EOTF(double x);
