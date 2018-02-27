Class Community.GroupPost Extends %Persistent [ DependsOn = (Community.Group, Community.Member) ]
{

Relationship GroupClass As Community.Group [ Cardinality = one, Inverse = Posts, OnDelete = cascade, Required ];

Relationship Post As Community.Post [ Cardinality = one, Inverse = GroupsClass, OnDelete = cascade, Required ];

Index GroupPost On (GroupClass, Post) [ Unique ];

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

