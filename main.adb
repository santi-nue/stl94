
with Ada.Streams;
with Ada.Text_IO; use Ada.Text_IO;
with XML.Input_Sources; use XML.Input_Sources;
with XML.Sax; use XML.Sax;
with XML.Sax.Readers; use XML.Sax.Readers;
with XML.Events; use XML.Events;

procedure Main is
   package Stream_IO is new Ada.Streams.Stream_IO (File_Type => Ada.Text_IO.File_Type);
   File : Ada.Text_IO.File_Type;
   Stream : Stream_IO.Stream_Access;
   Handler : XML.Sax.Event_Handler'Class;

   -- Custom event handler to wrap the stream in a root element
   type Root_Wrapper_Handler is new XML.Sax.Event_Handler with record
      Started : Boolean := False;
   end record;

   overriding procedure Start_Document (H : in out Root_Wrapper_Handler) is
   begin
      -- Insert a root element at the start of the document
      Put_Line ("<Root>");
   end Start_Document;

   overriding procedure End_Document (H : in out Root_Wrapper_Handler) is
   begin
      -- Close the root element at the end of the document
      Put_Line ("</Root>");
   end End_Document;

   overriding procedure Start_Element (H : in out Root_Wrapper_Handler; E : in XML.Events.Start_Element_Event) is
   begin
      if not H.Started then
         H.Started := True;
         -- Output the start of the root element
         Put_Line ("<Root>");
      end if;
      -- Output the original start element
      Put_Line ("<" & E.Name & ">");
   end Start_Element;

   overriding procedure End_Element (H : in out Root_Wrapper_Handler; E : in XML.Events.End_Element_Event) is
   begin
      -- Output the original end element
      Put_Line ("</" & E.Name & ">");
   end End_Element;

begin
   -- Open the XML stream (for example, from a file)
   Ada.Text_IO.Open (File, Ada.Text_IO.In_File, "input.xml");
   Stream := Stream_IO.Stream (File);

   -- Initialize the custom event handler
   declare
      H : Root_Wrapper_Handler;
   begin
      -- Create and run the SAX reader
      XML.Sax.Readers.Sax_Read (Handler => H, Source => XML.Input_Sources.Stream (Stream));
   end;

   -- Close the file
   Ada.Text_IO.Close (File);
end Main;
