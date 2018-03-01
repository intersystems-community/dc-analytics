Include Community

Class Community.Group Extends %Persistent [ SqlTableName = GroupClass ]
{

Parameter DSTIME = "AUTO";

Property Nid As %Integer [ Required ];

Index IDKEY On Nid [ IdKey, Unique ];

Relationship Posts As Community.GroupPost [ Cardinality = many, Inverse = GroupClass ];

Property Name As %String(MAXLEN = 150);

Property Link As %String(MAXLEN = 250) [ SqlComputeCode = {set {*} = $$$Server _ "node/" _ {Nid}}, SqlComputed, SqlComputeOnChange = %%INSERT ];

Index Link On Link [ Unique ];

Property Description As %String(MAXLEN = 250);

Property Created As %TimeStamp;

Property Tags As %String;

Property PostsAmount As %Integer [ Calculated, SqlComputeCode = { set {*} = ##class(Community.Group).GetPostsAmount({Id})}, SqlComputed ];

Relationship Positions As History.ChampionshipPositions [ Cardinality = many, Inverse = GroupClass ];

Property Hash As %String;

ClassMethod GetPostsAmount(id) As %Integer
{
	set result = 0
	set sql = "Select Count(Id) As PostsAmount From Community.GroupPost Where GroupClass = ? "
	set rs = ##class(%SQL.Statement).%ExecDirect(,sql, id)
	if rs.%Next() {set result = rs.PostsAmount}
	Quit result
}

Storage Default
{
<Data name="GroupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Link</Value>
</Value>
<Value name="4">
<Value>Description</Value>
</Value>
<Value name="5">
<Value>Created</Value>
</Value>
<Value name="6">
<Value>Tags</Value>
</Value>
<Value name="7">
<Value>Hash</Value>
</Value>
</Data>
<DataLocation>^Community.GroupD</DataLocation>
<DefaultData>GroupDefaultData</DefaultData>
<IdLocation>^Community.GroupD</IdLocation>
<IndexLocation>^Community.GroupI</IndexLocation>
<StreamLocation>^Community.GroupS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}

