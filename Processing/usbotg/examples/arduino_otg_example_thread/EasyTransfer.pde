

import java.io.Serializable;
import struct.*;
import java.nio.ByteOrder;


// DATA STRUCTURE FOR EasyTRansfer (Can only be type short (8bit)

DATA_STRUCTURE data = new DATA_STRUCTURE();
@StructClass
public class DATA_STRUCTURE {

  @StructField(order = 0)
    public short param;

  @StructField(order = 1)
    public short value;
}

//*************************


void et_begin()
{
  DATA_STRUCTURE data = new DATA_STRUCTURE();
  try {
    byte[] buffer = JavaStruct.pack(data, ByteOrder.LITTLE_ENDIAN );
    size = buffer.length;
    rx_buffer = new byte[size+1];
    convert_buffer = new byte[size];
  }

  catch(StructException e) {
    println("something went wrong");
  }
}


int size;       //size of struct
byte[] rx_buffer; //address for temporary storage and parsing buffer
byte[] convert_buffer;
int rx_array_inx = 0;  //index for RX parsing buffer
byte rx_len;    //RX packet length according to the packet
byte calc_CS;     //calculated Chacksum
byte rx_cs;

boolean et_receive()
{
  // text(usb_avaliable(), 200, 200);
  //start off by looking for the header bytes. If they were already found in a previous call, skip it.
  if (rx_len == 0) {

    //this size check may be redundant due to the size check below, but for now I'll leave it the way it is.
    if (usb_avaliable() >4) 
    {

      //this will block until a 0x06 is found or buffer size becomes less then 3.
      while (usb_read () != 0x06) {
        //This will trash any preamble junk in the serial buffer
        //but we need to make sure there is enough in the buffer to process while we trash the rest
        //if the buffer becomes too empty, we will escape and try again on the next call
        if (usb_avaliable() < 3)
          return false;
      }
      // debug("found 0x06");
      //  debug("0x85=" + (byte)usb_read());
      if ((byte)usb_read_wait() == -123) {

        rx_len = (byte)usb_read_wait();
        debug("len=" +rx_len);
        //make sure the binary structs on both Arduinos are the same size.
        if (rx_len != size) {
          rx_len = 0;
          debug("notsame size");
          return false;
        }
      }
    }
  }

  //we get here if we already found the header bytes, the struct size matched what we know, and now we are byte aligned.
  if (rx_len != 0 && usb_avaliable() > rx_len ) {
    // debug("we are in sync");
    while (rx_array_inx <= rx_len) {
      rx_buffer[rx_array_inx++] = (byte)usb_read_wait();
    } 

    if (rx_len == (rx_array_inx-1)) {

      //seem to have got whole message
      //last uint8_t is CS
      calc_CS = rx_len;
      for (int i = 0; i<rx_len; i++) {
        calc_CS^=rx_buffer[i];
      } 
      if (calc_CS == rx_buffer[rx_array_inx-1]) {//CS good

        try {

          // Nasty hack by Mads - fixing little endian bug
          for (int i=0; i < rx_buffer.length-1; i=i+2)
          {
            convert_buffer[i] = rx_buffer[i+1];
            convert_buffer[i+1] = rx_buffer[i];
          }
          JavaStruct.unpack(data, convert_buffer, ByteOrder.LITTLE_ENDIAN ); //Little endian converseion does not work - hence the hack above.
        } 
        catch(StructException e) {
          println("something went wrong");
        }


        rx_len = 0;
        rx_array_inx = 0;
        // println(data.value);;
        return true;
      } else {
        //failed checksum, need to clear this out anyway
        rx_len = 0;
        rx_array_inx = 0;
        return false;
      }
    }
  }

  return false;
}




void et_send(DATA_STRUCTURE _data) {

  try {
    // Pack the class as a byte buffer

    byte[] buffer = JavaStruct.pack(_data, ByteOrder.LITTLE_ENDIAN );

    byte checksum = (byte) buffer.length;

    usb_write((byte)0x06);        // these magic bytes define the start
    usb_write((byte)0x85);        // of a message for EasyTransfer.
    usb_write((byte)checksum);    // The starter is followed by the length of the payload...

    for (int i = 0; i < buffer.length; i++) {
      usb_write((byte)buffer[i]); // ...the payload itself...
      checksum ^= buffer[i];
    }
    usb_write((byte)checksum);    // ...and a checksum (the length and each payload byte xor'ed)*/
  }
  catch(StructException e) {
    println("something went wrong");
  }
}

//To send data other than plain chars it would have to be prepared for sending with the above function, like so (example for int and String):
char[] et_prepareMessage(String toSend) {
  char[] buffer = new char[toSend.length()];
  for (int i = 0; i < toSend.length (); i++) {
    buffer[i] = toSend.charAt(i);
  }
  return buffer;
}



char[] et_prepareMessage(int toSend) {
  char[] buffer = new char[4];

  buffer[0] = (char) (toSend        & 0xFF);
  buffer[1] = (char)((toSend >>  8) & 0xFF);
  buffer[2] = (char)((toSend >> 16) & 0xFF);
  buffer[3] = (char)((toSend >> 24) & 0xFF);

  return buffer;
}

