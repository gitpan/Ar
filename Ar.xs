/* $Id: Ar.xs,v 1.3 1995/07/15 12:45:27 rik Exp $ */

#include <ar.h>
#include <arextern.h>

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

static int done_init=0;

static int
not_here(s)
char *s;
{
  croak("%s not implemented on this architecture", s);
  return -1;
}

void
init()
{
  ARStatusList	status;
  int		stat;

  if (! done_init)
  {
    if ((stat=ARInitialization(&status)) != AR_RETURN_OK)
    {
      croak("ARInitialization returned %d\n", stat);
    }
    done_init = 1;
  }
}

void
PrintARStatusList(value)
ARStatusList *value;          /* IN; value to print */
{
   int			i;         /* working index */
   ARStatusStruct	*tempPtr;   /* working pointer */
   char			*tempPtr2;  /* working pointer */
 
   (void) printf("Status List : %u items\n", value->numItems);
   if (value->numItems != 0)
   {
      tempPtr = value->statusList;
      for (i = 0; i < (int) value->numItems; i++)
      {
         switch (tempPtr->messageType)
         {
            case AR_RETURN_OK:
               tempPtr2 = "NOTE";
               break;
            case AR_RETURN_WARNING:
               tempPtr2 = "WARNING";
               break;
            case AR_RETURN_ERROR:
               break;
            default:
               tempPtr2 = "<unknown type>";
               break;
         }
         (void) printf(
              "Status Struct :\n   Message type : %s\n   Message number : %d\n",
              tempPtr2, tempPtr->messageNum);
         if (tempPtr->messageText == NULL)
            (void) printf("   Message: \n");
         else
            (void) printf("   Message: %s\n", tempPtr->messageText);
 
         tempPtr++;
      }
   }
}

MODULE = Remedy::Ar	PACKAGE = Remedy::Ar	PREFIX = AR

#############################################################################
# Entry Operations
#############################################################################

#   ARCreateEntry

#   ARDeleteEntry

void
ARGetEntry(control, schema, entryId)
  void *	control
  char *	schema
  char *	entryId
PPCODE:
  {
    int			stat;
    ARStatusList	status;
    ARFieldValueList	list;
    int			num;

    init();

    if ((stat = ARGetEntry((ARControlStruct *)control, schema,
      entryId,
      (ARInternalIdList *)NULL,
      &list,
      &status)) != AR_RETURN_OK)
    {
      warn("ARGetEntry returned %d\n", stat);
      PrintARStatusList(status);
    }
    EXTEND(sp, list.numItems);

    for (num=0; num<list.numItems; num++)
    {
      AV  *entry = newAV();
  
      av_push(entry,
        newSVnv((double)list.fieldValueList[num].fieldId));

      switch(list.fieldValueList[num].value.dataType)
      {
        case AR_DATA_TYPE_KEYWORD:
          av_push(entry,
            newSViv(list.fieldValueList[num].value.u.keyNum));
          break;

        case AR_DATA_TYPE_INTEGER:
          av_push(entry,
            newSVnv((double)list.fieldValueList[num].value.u.intVal));
          break;

        case AR_DATA_TYPE_REAL:
          av_push(entry,
            newSVnv((double)list.fieldValueList[num].value.u.realVal));
          break;

        case AR_DATA_TYPE_CHAR:
          av_push(entry,
            newSVpv(list.fieldValueList[num].value.u.charVal,
            strlen(list.fieldValueList[num].value.u.charVal)));
          break;

        case AR_DATA_TYPE_DIARY:
          av_push(entry,
            newSVpv(list.fieldValueList[num].value.u.diaryVal,
            strlen(list.fieldValueList[num].value.u.diaryVal)));
          break;

        case AR_DATA_TYPE_ENUM:
          av_push(entry,
            newSVnv((double)list.fieldValueList[num].value.u.enumVal));
          break;

        case AR_DATA_TYPE_TIME:
          av_push(entry,
            newSVnv((double)list.fieldValueList[num].value.u.timeVal));
          break;

        case AR_DATA_TYPE_BITMASK:
          av_push(entry,
            newSVnv((double)list.fieldValueList[num].value.u.maskVal));
          break;
      }

      PUSHs(newRV((SV *)entry));
    }
  }

#   ARSetEntry

void
ARGetListEntry(control, schema, qualifier, maxRetrieve)
  void *	control
  char *	schema
  unsigned int	maxRetrieve
  void *	qualifier
  PPCODE:
  {
    int			stat;
    ARStatusList	status;
    AREntryListList	list;
    unsigned int	numMatches;
    int			num, num2;

    init();

    if ((stat = ARGetListEntry((ARControlStruct *)control, schema,
      qualifier,
      (ARSortList *)NULL,
      maxRetrieve,
      &list,
      (unsigned int)NULL,
      &status)) != AR_RETURN_OK)
    {
      warn("ARGetListEntry returned %d\n", stat);
      PrintARStatusList(status);
    }

    EXTEND(sp, list.numItems);

    for (num=0; num<list.numItems; num++)
    {
      AV  *entry = newAV();
  
      av_push(entry,
        newSVpv(list.entryList[num].entryId,
        strlen(list.entryList[num].entryId)));
      av_push(entry,
        newSVpv(list.entryList[num].shortDesc,
        strlen(list.entryList[num].shortDesc)));
  
      PUSHs(newRV((SV *)entry));
    }
  }

#   ARMergeEntry

#############################################################################
# Schema Operations
#############################################################################

#   ARCreateSchema

#   ARDeleteSchema

void
ARGetSchema(control, schema)
  void *	control
  char *	schema
PPCODE:
  {
    int			stat;
    ARStatusList	status;
    ARFieldValueList	list;
    int			num;

    init();

    if ((stat = ARGetSchema((ARControlStruct *)control, schema,
      (ARInternalIdList *)NULL,
      (AREntryListFieldList *)NULL,
      (ARIndexList *)NULL,
      (char **)NULL,
      (ARTimestamp *)NULL,
      (char *)NULL,
      (char *)NULL,
      (char **)NULL,
      &status)) != AR_RETURN_OK)
    {
      warn("ARGetSchema returned %d\n", stat);
      PrintARStatusList(status);
    }
  }

#   ARSetSchema

void
ARGetListSchema(control, changedSince)
  void *	control
  int		changedSince
  PPCODE:
  {
    int			stat;
    ARStatusList	status;
    ARNameList		list;

    init();

    if ((stat = ARGetListSchema((ARControlStruct *)control,
      (ARTimestamp)changedSince, &list, &status)) != AR_RETURN_OK)
    {
      warn("ARGetListSchema returned %d\n", stat);
      PrintARStatusList(status);
    }

    for (stat=0; stat<list.numItems; stat++)
    {
      XPUSHs(sv_2mortal(
        newSVpv(list.nameList[stat], strlen(list.nameList[stat]))
      ));
    }
  }

#############################################################################
# Field Operations
#############################################################################

#   ARCreateField

#   ARDeleteField

void
ARGetField(control, schema, fieldId)
  void *	control
  char *	schema
  unsigned long	fieldId
  PPCODE:
  {
    int			stat;
    ARStatusList	status;
    ARDisplayList	list;
    int			num, num2;

    init();

    if ((stat = ARGetField((ARControlStruct *)control, schema, fieldId,
      (unsigned int *)NULL,
      (unsigned int *)NULL,
      (unsigned int *)NULL,
      (ARValueStruct *)NULL,
      (ARPermissionList *)NULL,
      (ARFieldLimitStruct *)NULL,
      &list,
      (char **)NULL,
      (ARTimestamp *)NULL,
      (char *)NULL,
      (char *)NULL,
      (char **)NULL,
      &status)) != AR_RETURN_OK)
    {
      warn("ARGetField returned %d\n", stat);
      PrintARStatusList(status);
    }

    EXTEND(sp, list.numItems);

    for (num=0; num<list.numItems; num++)
    {
      AV  *entry = newAV();
      AV  *names = newAV();
  
      av_push(entry,
        newSVpv(list.displayList[num].displayTag,
        strlen(list.displayList[num].displayTag)));
      av_push(entry,
        newSVpv(list.displayList[num].label,
        strlen(list.displayList[num].label)));
      av_push(entry, newSViv(list.displayList[num].labelLocation));
      av_push(entry, newSViv(list.displayList[num].type));
      av_push(entry, newSViv(list.displayList[num].length));
      av_push(entry, newSViv(list.displayList[num].numRows));
      av_push(entry, newSViv(list.displayList[num].option));
      av_push(entry, newSViv(list.displayList[num].x));
      av_push(entry, newSViv(list.displayList[num].y));
  
      PUSHs(newRV((SV *)entry));
    }
  }

#   ARSetField

void
ARGetListField(control, schema, changedSince)
  void *	control
  char *	schema
  int		changedSince
  PPCODE:
  {
    int			stat;
    ARStatusList	status;
    ARInternalIdList	list;

    init();

    if ((stat = ARGetListField((ARControlStruct *)control, schema,
      (ARTimestamp)changedSince,
      &list,
      &status)) != AR_RETURN_OK)
    {
      warn("ARGetListField returned %d\n", stat);
      PrintARStatusList(status);
    }

    for (stat=0; stat<list.numItems; stat++)
    {
      XPUSHs(sv_2mortal(newSVnv((double)list.internalIdList[stat])));
    }
  }

#############################################################################
# Menu Operations
#############################################################################

#   ARCreateCharMenu

#   ARDeleteCharMenu

#   ARExpandCharMenu

#   ARGetCharMenu

#   ARSetCharMenu

#   ARGetListCharMenu

#############################################################################
# Filter Operations
#############################################################################

#   ARCreateFilter

#   ARDeleteFilter

#   ARGetFilter

#   ARSetFilter

#   ARGetListFilter

#############################################################################
# Active Link Operations
#############################################################################

#   ARCreateActiveLink

#   ARDeleteActiveLink

#   ARGetActiveLink

#   ARSetActiveLink

#   ARGetListActiveLink

#############################################################################
# AdminExt Operations
#############################################################################

#   ARCreateAdminExt

#   ARDeleteAdminExt

#   ARGetAdminExt

#   ARSetAdminExt

#   ARGetListAdminExt

#   ARExecuteAdminExt

#############################################################################
# Miscellaneous Operations
#############################################################################

void
ARVerifyUser(control)
  void *	control
  PPCODE:
  {
    int			stat;
    ARBoolean		adminFlag;
    ARBoolean		customFlag;
    ARStatusList	status;

    init();

    if ((stat = ARVerifyUser((ARControlStruct *)control, &adminFlag,
      &customFlag, &status)) != AR_RETURN_OK)
    {
      warn("ARVerifyUser returned %d\n", stat);
      PrintARStatusList(status);
    }
  }


void
ARGetListServer()
  PPCODE:
  {
    int			stat;
    ARStatusList	status;
    ARNameList		list;

    init();

    if ((stat = ARGetListServer(&list, &status)) != AR_RETURN_OK)
    {
      warn("ARGetListServer returned %d\n", stat);
      PrintARStatusList(status);
    }

    for (stat=0; stat<list.numItems; stat++)
    {
      XPUSHs(sv_2mortal(
        newSVpv(list.nameList[stat], strlen(list.nameList[stat]))
      ));
    }
  }

#   ARExport

#   ARImport

void
ARGetListGroup(control)
  void *	control
  PPCODE:
  {
    int			stat;
    ARStatusList	status;
    ARGroupInfoList	list;
    int			num, num2;

    init();

    if ((stat = ARGetListGroup((ARControlStruct *)control, &list, &status))
      != AR_RETURN_OK)
    {
      warn("ARGetListGroup returned %d\n", stat);
      PrintARStatusList(status);
    }

    EXTEND(sp, list.numItems);

    for (num=0; num<list.numItems; num++)
    {
      AV  *entry = newAV();
      AV  *names = newAV();
  
      av_push(entry, newSVnv((double)list.groupList[num].groupId));
      av_push(entry, newSViv(list.groupList[num].groupType));
      for (num2=0; num2<list.groupList[num].groupName.numItems; num2++)
      {
        av_push(names,
          newSVpv(list.groupList[num].groupName.nameList[num2],
          strlen(list.groupList[num].groupName.nameList[num2])));
      }
      av_push(entry, newRV((SV *)names));
  
      PUSHs(newRV((SV *)entry));
    }
  }

#   ARGetServerInfo

#   ARSetServerInfo

#   ARDecodeStatusHistory

#   ARDecodeDiary

SV *
ARLoadARQualifierStruct(control, schema, qualString)
  void *	control
  char *	schema
  char *	qualString
  CODE:
  {
    int			stat;
    ARStatusList	status;
    ARQualifierStruct	*qualifier;

    init();

    if ((qualifier = (ARQualifierStruct *)malloc(sizeof(ARQualifierStruct)))
      == (ARQualifierStruct *) NULL)
    {
      croak("not enough memory to allocate an ARQualifierStruct");
    }

    if ((stat = ARLoadARQualifierStruct((ARControlStruct *)control,
      schema, (char *)NULL, qualString, qualifier,
      &status)) != AR_RETURN_OK)
    {
      warn("ARLoadARQualifierStruct returned %d\n", stat);
      PrintARStatusList(status);
      XSRETURN_UNDEF;
    }

    ST(0) = newSViv((IV)qualifier);
  }

#############################################################################
# Miscellaneous Support Functions (Not part of the AR API)
#############################################################################

void
newcontrol()
  PPCODE:
  {
    ARControlStruct	*control;

    if ((control = (ARControlStruct *)malloc(sizeof(ARControlStruct)))
      == (ARControlStruct *) NULL)
    {
      croak("not enough memory to allocate an ARControlStruct");
    }

    control->cacheId = 0;
    strcpy(control->user, "");
    strcpy(control->password, "");
    strcpy(control->language, "C");
    strcpy(control->server, "");

    PUSHs(newSViv((IV)control));
  }

void
printcontrol(control)
  void *	control
  PPCODE:
  {
    if (control == NULL)
    {
      croak("control is NULL");
    }
    printf("Control structure:\n");
    printf("CacheId: %ld\n", ((ARControlStruct *)control)->cacheId);
    printf("Timestamp: %ld\n", ((ARControlStruct *)control)->operationTime);
    printf("User: %s\n", ((ARControlStruct *)control)->user);
    printf("Password: %s\n", ((ARControlStruct *)control)->password);
    printf("Language: %s\n", ((ARControlStruct *)control)->language);
    printf("Server: %s\n", ((ARControlStruct *)control)->server);
  }

void
setuser(control, user, password)
  void *	control
  char *	user
  char *	password
  PPCODE:
  {
    int			stat;
    ARStatusList 	status;

    strncpy(((ARControlStruct *)control)->user, user, AR_MAX_NAME_SIZE);
    strncpy(((ARControlStruct *)control)->password, password, AR_MAX_NAME_SIZE);

    if ((stat = ARVerifyUser((ARControlStruct *)control,
      (ARBoolean *)NULL, (ARBoolean *)NULL, &status)) != AR_RETURN_OK)
    {
      warn("ARVerifyUser returned %d\n", stat);
      PrintARStatusList(status);
    }
  }

void
setlanguage(control, language)
  void *	control
  char *	language
  PPCODE:
  {
    strncpy(((ARControlStruct *)control)->language, language, AR_MAX_NAME_SIZE);
  }

void
setserver(control, server)
  void *	control
  char *	server
  PPCODE:
  {
    strncpy(((ARControlStruct *)control)->server, server, AR_MAX_NAME_SIZE);
  }
