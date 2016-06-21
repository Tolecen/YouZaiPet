//
//  ChinaMapShift.h
//  ChinaMapShift
//
//  Most code created by someone anonymous.
//  transformFromGCJToWGS() added by Fengzee (fengzee@fengzee.com).
//

#ifndef ChinaMapShift_ChinaMapShift_h
#define ChinaMapShift_ChinaMapShift_h

typedef struct {
    double lng;
    double lat;
} LocationM;

LocationM transformFromWGSToGCJ(LocationM wgLoc);
LocationM transformFromGCJToWGS(LocationM gcLoc);
LocationM bd_encrypt(LocationM gcLoc);
LocationM bd_decrypt(LocationM bdLoc);

#endif
