#include <cstring>
#include "mex.h"
#include "..\\zlib1211\\zlib-1.2.11\\zlib.h"


void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]){
	int dir= (int)*((double*)mxGetPr(prhs[0]));
	if (dir==0){
		int lengthout = (int)*((double*)mxGetPr(prhs[1]));
		int lengthin = (int)*((double*)mxGetPr(prhs[2]));
		int datatype = (int)*((double*)mxGetPr(prhs[3]));
		unsigned char *input = (unsigned char*)mxGetPr(prhs[4]);
		unsigned char *buf = new unsigned char[lengthout];
		
		
		

		z_stream d_stream; /* decompression stream */
		d_stream.zalloc = 0;
		d_stream.zfree = 0;
		d_stream.opaque = (voidpf)0;
		d_stream.next_in  = (Bytef*)input;
		d_stream.avail_in = 0;
		d_stream.next_out = (Bytef*)buf;

		int err = inflateInit2(&d_stream,32+MAX_WBITS);
		
		while (d_stream.total_out < lengthout && d_stream.total_in < lengthin) {
			d_stream.avail_in = d_stream.avail_out = 1; /* force small buffers */
			err = inflate(&d_stream, Z_NO_FLUSH);
			if (err == Z_STREAM_END) break;
		}

		err = inflateEnd(&d_stream);
		double *output;
		switch (datatype){
			case 1:
				plhs[0] = mxCreateDoubleMatrix(1,lengthout,mxREAL);
				output = mxGetPr(plhs[0]);
				for (int i=0; i<lengthout; i++){
					output[i] = buf[i];
				}
				break;
			case 2:
				plhs[0] = mxCreateDoubleMatrix(1,lengthout/2,mxREAL);
				output = mxGetPr(plhs[0]);
				{
					short *pbuf = (short*)buf;
					for (int i=0; i<lengthout/2; i++){
						output[i] = pbuf[i];
					}
				}
				break;
			case 3:
				plhs[0] = mxCreateDoubleMatrix(1,lengthout/4,mxREAL);
				output = mxGetPr(plhs[0]);
				{
					int *pbuf = (int*)buf;
					for (int i=0; i<lengthout/4; i++){
						output[i] = pbuf[i];
					}
				}
				break;
			case 4:
				plhs[0] = mxCreateDoubleMatrix(1,lengthout/4,mxREAL);
				output = mxGetPr(plhs[0]);
				{
					float *pbuf = (float*)buf;
					for (int i=0; i<lengthout/4; i++){
						output[i] = pbuf[i];
					}
				}
				break;
		}
		delete [] buf;
	}
	else{
		int lengthin = (int)*((double*)mxGetPr(prhs[1]));
		int datatype = (int)*((double*)mxGetPr(prhs[2]));
		int datasize = lengthin*datatype;
		unsigned char *input = (unsigned char*)mxGetPr(prhs[3]);
		z_stream strm;
		strm.zalloc = Z_NULL;
		strm.zfree = Z_NULL;
		strm.opaque = Z_NULL;
		int err = deflateInit2((z_streamp)(&strm), Z_DEFAULT_COMPRESSION, Z_DEFLATED,
				   MAX_WBITS + 16, 8, Z_DEFAULT_STRATEGY);
		strm.next_in  = (z_const unsigned char *)input;
		unsigned char*compr = new unsigned char[datasize];
		strm.next_out = compr;

		while (strm.total_in != datasize && strm.total_out < datasize) {
			strm.avail_in = strm.avail_out = 1; 
			err = deflate(&strm, Z_NO_FLUSH);
		}
		for (;;) {
			strm.avail_out = 1;
			err = deflate(&strm, Z_FINISH);
			if (err == Z_STREAM_END) break;
		}
		plhs[0] = mxCreateNumericMatrix(1,strm.total_out,mxUINT8_CLASS,mxREAL);
		unsigned char *output = (unsigned char*)mxGetPr(plhs[0]);
		std::memcpy(output,compr,strm.total_out);				
		err = deflateEnd(&strm);
		delete [] compr;
	}

  return;
}