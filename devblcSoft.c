/* devblcSoft.c */
/* Example device support module */

#include <stddef.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include "alarm.h"
#include "cvtTable.h"
#include "dbDefs.h"
#include "dbAccess.h"
#include "recGbl.h"
#include "recSup.h"
#include "devSup.h"
#include "link.h"
#include "blcRecord.h"
#include "epicsExport.h"
#include "drvXxx.h"

/*Create the dset for devblcSoft */
static long init_record();
static long read_blc();
struct {
	long		number;
	DEVSUPFUN	report;
	DEVSUPFUN	init;
	DEVSUPFUN	init_record;
	DEVSUPFUN	get_ioint_info;
	DEVSUPFUN	read_blc;
}devblcSoft={
	5,
	NULL,
	NULL,
	init_record,
	NULL,
	read_blc,
};
epicsExportAddress(dset,devblcSoft);


static long init_record(pblc)
    struct blcRecord	*pblc;
{
    if(recGblInitConstantLink(&pblc->inp,DBF_DOUBLE,&pblc->val))
         pblc->udf = FALSE;
    return(0);
}

static long read_blc(pblc)
    struct blcRecord	*pblc;
{
    long status;
    char bo[16]="Brake unlock";
    char bc[16]="Brake lock";
    int i;
    if(pblc->val==0)
    {
    blc_send_mess(pblc->card,pblc->bh);
    for(i=0;i<16;i++) pblc->status[i] = bc[i];
    }
    if(pblc->val==1)
    {
    blc_send_mess(pblc->card,pblc->bl);
    for(i=0;i<16;i++) pblc->status[i] = bo[i];

    }

    status = dbGetLink(&(pblc->inp),DBF_DOUBLE, &(pblc->val),0,0);
    /*If return was succesful then set undefined false*/
    if(!status) pblc->udf = FALSE;
    return(0);
}
