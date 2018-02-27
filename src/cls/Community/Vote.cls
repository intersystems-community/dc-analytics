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

