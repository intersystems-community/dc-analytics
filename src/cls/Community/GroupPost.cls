Class Community.GroupPost Extends %Persistent
{

Relationship GroupClass As Community.Group [ Cardinality = one, Inverse = Posts, OnDelete = cascade, Required ];

Relationship Post As Community.Post [ Cardinality = one, Inverse = GroupsClass, OnDelete = cascade, Required ];

Index GroupPost On (GroupClass, Post) [ Unique ];

ClassMethod Insert(groupId, postId) As %Status
{
	Set st = $$$OK
	Return:##class(Community.GroupPost).GroupPostExists(groupId,postId) st
	
	&sql(
		Insert Into Community.GroupPost (GroupClass, Post)
		Values (:groupId, :postId)
	)
	
	If (SQLCODE'=0) {
		Set st = $$$ERROR($$$SQLError, SQLCODE, $g(%msg))
	}
	
	Return st
}

Storage Default
{
<Data name="GroupPostDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>GroupClass</Value>
</Value>
<Value name="3">
<Value>Post</Value>
</Value>
</Data>
<DataLocation>^Community.GroupPostD</DataLocation>
<DefaultData>GroupPostDefaultData</DefaultData>
<IdLocation>^Community.GroupPostD</IdLocation>
<IndexLocation>^Community.GroupPostI</IndexLocation>
<StreamLocation>^Community.GroupPostS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}

