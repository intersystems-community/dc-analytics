/// 
Class BI.PC Extends %DeepSee.SubjectArea [ DependsOn = (BI.Post, BI.CommentCopy, BI.ViewsHistoryCopy), ProcedureBlock ]
{

/// SubjectArea definition from Architect.
XData SubjectArea [ XMLNamespace = "http://www.intersystems.com/deepsee/subjectarea" ]
{
<subjectArea xmlns="http://www.intersystems.com/deepsee/subjectarea" name="PC" displayName="PC" disabled="false" baseCube="Post,CommentCopy,ViewsHistoryCopy" disableListingGroups="false">
</subjectArea>
}

ClassMethod %OnGetFilterSpec(pFilterSpec As %String) As %String
{
	if ($username = "esdevcom") {
	//if ($username = "UnknownUser") {
		quit "[Language].[H1].[Language].[es]"
	} else {
		quit "[Language].[H1].[Language].[en]"
	}
}

Parameter DOMAIN;

}
