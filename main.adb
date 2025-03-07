with Ada.Text_IO; use Ada.Text_IO;
with SAX.Parsers, SAX.Events, Input_Sources.Strings;

procedure Parse_XML_Fragments is
   type My_Handler is new SAX.Events.Default_Handler with null record;

   overriding procedure Start_Element (Handler : in out My_Handler;
                                       Name    : in String;
                                       Attrs   : in SAX.Events.Attributes) is
   begin
      Put_Line ("Start Element: " & Name);
   end Start_Element;

   overriding procedure End_Element (Handler : in out My_Handler;
                                     Name    : in String) is
   begin
      Put_Line ("End Element: " & Name);
   end End_Element;

   Parser : SAX.Parsers.SAX_Parser := SAX.Parsers.Create_SAX_Parser;
   Handler : My_Handler;
   Fragment1 : constant String := "<status><x>123</x><y>456</y></status>";
   Fragment2 : constant String := "<status><x>234</x><y>567</y></status>";
begin
   -- Set the handler for the parser
   SAX.Parsers.Set_Content_Handler (Parser, Handler);

   -- Parse each fragment separately
   SAX.Parsers.Parse (Parser, Input_Sources.Strings.Create_Input_Source (Fragment1));
   SAX.Parsers.Parse (Parser, Input_Sources.Strings.Create_Input_Source (Fragment2));
end Parse_XML_Fragments;
