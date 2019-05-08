package de.c3ma.ollo.mockup;

import java.io.IOException;
import java.io.InterruptedIOException;
import java.net.ServerSocket;
import java.net.Socket;

import org.luaj.vm2.LuaFunction;
import org.luaj.vm2.LuaTable;
import org.luaj.vm2.LuaValue;
import org.luaj.vm2.lib.ThreeArgFunction;
import org.luaj.vm2.lib.TwoArgFunction;

/**
 * created at 29.12.2017 - 01:29:40<br />
 * creator: ollo<br />
 * project: WS2812Emulation<br />
 * $Id: $<br />
 * @author ollo<br />
 */
public class ESP8266Net extends TwoArgFunction {
    
    public static final int PORTNUMBER_OFFSET = 4000;
    
    @Override
    public LuaValue call(LuaValue modname, LuaValue env) {
        env.checkglobals();
        LuaValue net = LuaValue.tableOf();
        net.set("createServer", new CreateServerFunction());
        
        //FIXME net.set("send", new SendFunction());
        net.set("TCP", "TCP");
        env.set("net", net);
        env.get("package").get("loaded").set("net", net);        
        return net;
    }
    
    private class CreateServerFunction extends TwoArgFunction {

        @Override
        public LuaValue call(LuaValue modname, LuaValue globalEnv) {
        	LuaValue cs = LuaValue.tableOf();
        	cs.set("listen", new ListenFunction());
        	return cs;
        }
        
    }
    
    private class ListenFunction extends ThreeArgFunction {

        @Override
        public LuaValue call(LuaValue self, LuaValue port, LuaValue function) {
        	if(!self.istable()) {
        		return NIL;
        	}
        	
            int portnumber = port.checkint();
            LuaFunction onListenFunction = function.checkfunction();

            System.out.println("[Net] listening " + portnumber + "(simulating at " + (PORTNUMBER_OFFSET+ portnumber) + ")");
            
            try
            {
                ServerSocket serverSocket = new ServerSocket(PORTNUMBER_OFFSET+portnumber);
                serverSocket.setSoTimeout( 60000 ); // Timeout after one minute
            
                Socket client = serverSocket.accept();
                
            }
            catch ( InterruptedIOException iioe )
            {
              System.err.println( "Timeout nach einer Minute!" );
            } catch (IOException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
            System.out.println("[Net] server running");
            return LuaValue.valueOf(true);
        }
        
    }
}
