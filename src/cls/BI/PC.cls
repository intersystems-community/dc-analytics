/// 
Class BI.PC Extends %DeepSee.SubjectArea [ DependsOn = (BI.Post, BI.CommentCopy), ProcedureBlock ]
{

/// SubjectArea definition from Architect.
XData SubjectArea [ XMLNamespace = "http://www.intersystems.com/deepsee/subjectarea" ]
{
<subjectArea xmlns="http://www.intersystems.com/deepsee/subjectarea" name="PC" displayName="PC" disabled="false" baseCube="Post,CommentCopy,ViewsHistoryCopy" disableListingGroups="false">
</subjectArea>
}

Parameter DOMAIN;

}

