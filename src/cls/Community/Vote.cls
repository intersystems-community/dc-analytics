/// Immutable
Class Community.Vote Extends %Persistent [ DependsOn = (Community.Member, Community.Post, Community.Comment) ]
{

Parameter DSTIME = "AUTO";

Property Id As %Integer [ Required ];

Index IDKEY On Id [ IdKey, Unique ];

Property Created As %TimeStamp [ Required ];

Relationship Author As Community.Member [ Cardinality = one, Inverse = Votes, OnDelete = cascade, Required ];

Relationship Post As Community.Post [ Cardinality = one, Inverse = Votes, OnDelete = cascade ];

Index PostIndex On Post;

Relationship Comment As Community.Comment [ Cardinality = one, Inverse = Votes, OnDelete = cascade ];

Index CommentIndex On Comment;

Property Value As %Integer(VALUELIST = ",-1,1") [ Required ];

ClassMethod Insert(Id, Created, EntityId, EntityType, Uid, Value) As %Status
{
 	If ..%ExistsId(Id) {
 		Return $$$OK
	} 
	Set Vote = ..%New()
	Set Vote.Id = Id
	Set Vote.Created = Created
	Set Vote.Value = Value
	
	If ((EntityType = "node") && (##class(Community.Post).%ExistsId(EntityId))) {	
		Do Vote.PostSetObjectId(EntityId)
	} Else {
		
		set ID = $Case(EntityType, "node":"answer", :EntityType) _"||" _ EntityId
		
		if (##class(Community.Comment).%ExistsId(ID)) {
			Do Vote.CommentSetObjectId(ID)
		}
		Else {
			Quit $$$OK
		}
	}
	
	if (##class(Community.Member).%ExistsId(Uid)) {
		Do Vote.AuthorSetObjectId(Uid)
	}
	Else {
		Quit $$$OK
	}
	
	Set st = Vote.%Save()
	
	Return st
}

Storage Default
{
<Data name="VoteDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Created</Value>
</Value>
<Value name="3">
<Value>Author</Value>
</Value>
<Value name="4">
<Value>Post</Value>
</Value>
<Value name="5">
<Value>Comment</Value>
</Value>
<Value name="6">
<Value>Hash</Value>
</Value>
<Value name="7">
<Value>Value</Value>
</Value>
</Data>
<DataLocation>^Community.VoteD</DataLocation>
<DefaultData>VoteDefaultData</DefaultData>
<IdLocation>^Community.VoteD</IdLocation>
<IndexLocation>^Community.VoteI</IndexLocation>
<StreamLocation>^Community.VoteS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}

