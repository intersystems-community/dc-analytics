```
// export globals from COMMUNITYPUBLIC
set gbl="Com*D.GBL,His*D.GBL"
s fn="DCPublic_globals.gz"
s s=##class(%Stream.FileBinaryGzip).%New() do s.LinkToFile(fn) do $System.OBJ.ExportToStream(gbl,s,"/mapped") do s.%Save() kill s
```
