Include Community

Class Community.Comment Extends %Persistent [ DependsOn = (Community.Member, Community.Post, Community.Utils.Hash) ]
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

Property TextHash As %String;

Index TextHashIndex On TextHash;

Relationship Votes As Community.Vote [ Cardinality = many, Inverse = Comment ];

Property AcceptedAnswerTS As %TimeStamp;

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
	
	Set modify = 0
	If (Correct = 1) & (Comment.AcceptedAnswerTS = "") {
		Set Comment.AcceptedAnswerTS = $zdt($now(300),3)
		Set modify = 1
	} ElseIf (Correct = 0) & (Comment.AcceptedAnswerTS '= "") {
		Set Comment.AcceptedAnswerTS = ""
		Set modify = 1
	}
	
	if modify = 1 {
		Set Comment.Post.AcceptedAnswerTS = Comment.AcceptedAnswerTS
		Set st = Comment.Post.%Save()
	}
	
	Set TextHash = ##class(Community.Utils.Hash).Hash(Text)
	
	If TextHash '= Comment.TextHash {
		Set Text = $replace(Text,"</p>"," ")
		Set reg = ##class(%Regex.Matcher).%New("<(([^>]|\n)*)>")
		Set reg.Text = Text
		Set Text = reg.ReplaceAll("")
		Set Text = $replace(Text,"&nbsp;"," ")
		Set Text = $replace(Text,"&gt;",">")
		Set Text = $replace(Text,"&lt;","<")
		Set Text = $replace(Text,"&amp;","&")
		Set Text = $replace(Text,"&quot;","""")
		Set Text = $replace(Text,"$#39;","'")
		Set Comment.Text = Text
		Set Comment.TextHash = TextHash
	}
	
	set st = Comment.%Save()
	
	return st
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
<Value name="12">
<Value>TextHash</Value>
</Value>
<Value name="13">
<Value>AsseptedAnswerTS</Value>
</Value>
<Value name="14">
<Value>AcceptedAnswerTS</Value>
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

