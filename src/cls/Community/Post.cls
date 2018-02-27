Include Community

Class Community.Post Extends %Persistent [ DependsOn = Community.Member ]
{

Parameter DSTIME = "AUTO";

Property Nid As %Integer [ Required ];

Index IDKEY On Nid [ IdKey, Unique ];

Property Type As %String(VALUELIST = ",code_package,documentation,learning_track,video,post");

Property Tags As %String(MAXLEN = 350);

Property Views As %Integer;

Property AvgVote As %Integer;

Property VotesAmount As %Integer;

Property Name As %String(MAXLEN = 250);

Property Created As %TimeStamp;

Property Published As %Boolean;

Property PublishedDate As %TimeStamp;

Property Deleted As %Boolean;

Property Text As %String(MAXLEN = "");

Property Link As %String(MAXLEN = 150) [ SqlComputeCode = {set {*} = $$$Server _ "node/" _ {Nid}}, SqlComputed, SqlComputeOnChange = %%INSERT ];

Index Link On Link [ Unique ];

Relationship Comments As Community.Comment [ Cardinality = many, Inverse = Post ];

Relationship Author As Community.Member [ Cardinality = one, Inverse = Posts, OnDelete = cascade, Required ];

Index AuthorIndex On Author;

Relationship GroupsClass As Community.GroupPost [ Cardinality = many, Inverse = Post ];

Property CommentsAmount As %Integer [ Calculated, SqlComputeCode = { set {*} = ##class(Community.Post).GetCommentsAmount({Id})}, SqlComputed ];

Property PostType As %String(VALUELIST = ",Question,Article,Announcement");

/// Hash of input row, used to build this object
Property Hash As %String;

Property SubsCount As %Integer;

Property HasCorrectAnswer As %Boolean;

Relationship Votes As Community.Vote [ Cardinality = many, Inverse = Post ];

Property AcceptedAnswerTS As %TimeStamp;

ClassMethod GetCommentsAmount(id) As %Integer
{
	set result = 0
	set sql = "Select Count(Id) As CommentsAmount From Community.Comment Where Post = ? "
	set rs = ##class(%SQL.Statement).%ExecDirect(,sql, id)
	if rs.%Next() {set result = rs.CommentsAmount}
	Quit result
}

Storage Default
{
<Data name="PostDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Tags</Value>
</Value>
<Value name="3">
<Value>Views</Value>
</Value>
<Value name="4">
<Value>AvgVote</Value>
</Value>
<Value name="5">
<Value>VotesAmount</Value>
</Value>
<Value name="6">
<Value>Name</Value>
</Value>
<Value name="7">
<Value>Created</Value>
</Value>
<Value name="8">
<Value>Text</Value>
</Value>
<Value name="9">
<Value>Link</Value>
</Value>
<Value name="10">
<Value>Author</Value>
</Value>
<Value name="11">
<Value>Type</Value>
</Value>
<Value name="12">
<Value>Published</Value>
</Value>
<Value name="13">
<Value>PublishedDate</Value>
</Value>
<Value name="14">
<Value>Deleted</Value>
</Value>
<Value name="15">
<Value>PostType</Value>
</Value>
<Value name="16">
<Value>Hash</Value>
</Value>
<Value name="17">
<Value>SubsCount</Value>
</Value>
<Value name="18">
<Value>HaveAnswer</Value>
</Value>
<Value name="19">
<Value>HaveCorrectAnswer</Value>
</Value>
<Value name="20">
<Value>HasCorrectAnswer</Value>
</Value>
<Value name="21">
<Value>AcceptedAnswerTS</Value>
</Value>
</Data>
<DataLocation>^Community.PostD</DataLocation>
<DefaultData>PostDefaultData</DefaultData>
<IdLocation>^Community.PostD</IdLocation>
<IndexLocation>^Community.PostI</IndexLocation>
<StreamLocation>^Community.PostS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}

