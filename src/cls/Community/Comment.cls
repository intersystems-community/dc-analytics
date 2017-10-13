Include Community

Class Community.Comment Extends %Persistent
{

Parameter DSTIME = "AUTO";

Property Id As %Integer [ Required ];

Index IDKEY On (Type, Id) [ IdKey, Unique ];

Property AvgVote As %Integer;

Property VotesAmount As %Integer;

Relationship Post As Community.Post [ Cardinality = one, Inverse = Comments, OnDelete = cascade, Required ];

Index PostIndex On Post;

Relationship Author As Community.Member [ Cardinality = one, Inverse = Comments, OnDelete = cascade, Required ];

Index AuthorIndex On Author;

Property Link As %String(MAXLEN = 250) [ SqlComputeCode = {set {*} = $$$Server _ $case({Type}, "comment":"comment/", :"node/") _ {Id}}, SqlComputed, SqlComputeOnChange = %%INSERT ];

Index Link On Link [ Unique ];

Property Created As %TimeStamp;

Property Text As %String(MAXLEN = "");

Property Type As %String(VALUELIST = ",answer,comment");

Property Deleted As %Boolean;

Property Correct As %Boolean;

/// Hash of input row, used to build this object
Property Hash As %String;

Relationship Votes As Community.Vote [ Cardinality = many, Inverse = Comment ];

ClassMethod Upsert(Id, Type, Nid, Created, Uid, AvgVote, VotesAmount, Text, Correct) As %Status
{
	Set Id1 = Type _ "||" _ Id
 	Set Hash = ##class(Community.Utils.Hash).Hash(Id, Type, Nid, Created, Uid, AvgVote, VotesAmount, Text, Correct) 
 	Return:(Hash=..HashGetStored(Id1)) $$$OK
 	
 	If ..%ExistsId(Id1) {
 		Set Comment = ..%OpenId(Id1)
	} Else {
		Set Comment = ..%New()
		Set Comment.Id = Id
		Set Comment.Type = Type
		Do Comment.PostSetObjectId(Nid)
		Do Comment.AuthorSetObjectId(Uid)
	}
	
	Set Comment.Hash = Hash
	Set Comment.Created = Created
	Set Comment.AvgVote = AvgVote
	Set Comment.VotesAmount = VotesAmount
	Set Comment.Correct = Correct
	
	set Text = $replace(Text,"</p>"," ")
	set reg = ##class(%Regex.Matcher).%New("<(([^>]|\n)*)>")
	set reg.Text = Text
	set Text = reg.ReplaceAll("")
	
	set Text = $replace(Text,"&nbsp;"," ")
	set Text = $replace(Text,"&gt;",">")
	set Text = $replace(Text,"&lt;","<")
	set Text = $replace(Text,"&amp;","&")
	set Text = $replace(Text,"&quot;","""")
	set Text = $replace(Text,"$#39;","'")
	Set Comment.Text = Text
	
	Set st = Comment.%Save()
	
	Return st
}

Storage Default
{
<Data name="CommentDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AvgVote</Value>
</Value>
<Value name="3">
<Value>VotesAmount</Value>
</Value>
<Value name="4">
<Value>Post</Value>
</Value>
<Value name="5">
<Value>Author</Value>
</Value>
<Value name="6">
<Value>Link</Value>
</Value>
<Value name="7">
<Value>Created</Value>
</Value>
<Value name="8">
<Value>Text</Value>
</Value>
<Value name="9">
<Value>Deleted</Value>
</Value>
<Value name="10">
<Value>Hash</Value>
</Value>
<Value name="11">
<Value>Correct</Value>
</Value>
</Data>
<DataLocation>^Community.CommentD</DataLocation>
<DefaultData>CommentDefaultData</DefaultData>
<IdLocation>^Community.CommentD</IdLocation>
<IndexLocation>^Community.CommentI</IndexLocation>
<StreamLocation>^Community.CommentS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}

