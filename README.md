# bashTable

This is a script to print data in a table, you can change the delimiter of columns or the chars of the lines.
Inclusive is possible to change the color of the lines or the data. Both in header or data table.

## Example usage

In this example, pass the data as a variable, is neccesary that every row are in a new line and the delimiter of colum if not present, is the standar char "_"
Presume that the data contain an string with this conditions.
```bash
.\table.sh $data
```
## Options
 If you want to change column separator or other thing. Are some options aviable to do that.
 - h:   Show the help panel
 - d:   Delimiter column char. ex: -d "|"
 - l:   Change the chars of the lines of data
 - t:   Change the chars of the lines of header
 - c:   Change the color[¹]
 - v:   Show version of the script

```bash
./table.sh -l "% $ %" -t "@ # ¬" -c "Red Blue Green Yellow" $data
```

## Screenshot

![Screenshot1](https://raw.githubusercontent.com/adesduende/bashTable/master/screenshot1.png)
![Screenshot1](https://raw.githubusercontent.com/adesduende/bashTable/master/screenshot_000.png)

[^note]:Colores existentes [Black Red Green Orange Blue Purple Cyan Light_Gray Dark_Gray Light_Red Light_Green Yellow Light_Blue Light_Purple Light_Cyan White]