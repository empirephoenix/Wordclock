package de.c3ma.ollo.mockup;

import org.luaj.vm2.LuaTable;
import org.luaj.vm2.LuaValue;
import org.luaj.vm2.lib.OneArgFunction;
import org.luaj.vm2.lib.TwoArgFunction;
import org.luaj.vm2.lib.ZeroArgFunction;

/**
 * created at 28.12.2017 - 23:34:04<br />
 * creator: ollo<br />
 * project: WS2812Emulation<br />
 * $Id: $<br />
 * @author ollo<br />
 */
public class ESP8266Ws2812 extends TwoArgFunction {

    @Override
    public LuaValue call(LuaValue modname, LuaValue env) {
        env.checkglobals();
        final LuaTable ws2812 = new LuaTable();
        ws2812.set("init", new init());
        ws2812.set("write", new write());
        env.set("ws2812", ws2812);
        env.get("package").get("loaded").set("ws2812", ws2812);
        return ws2812;
    }

    private class init extends ZeroArgFunction {

        @Override
        public LuaValue call() {
            System.out.println("[WS2812] init");
            return LuaValue.valueOf(true);
        }
        
    }
    
    private class write extends OneArgFunction {

        @Override
        public LuaValue call(LuaValue arg) {
            if (arg.isstring()) {
                int length = arg.checkstring().rawlen();
                System.out.println("[WS2812] write length:" + length);
                if ((length % 3) == 0) {
                    byte[] array = arg.toString().getBytes();
                    for (int i = 0; i < length; i+=3) {
                        /*System.out.println(
                                array[i+0] + " " 
                                + array[i+1] + " "
                                + array[i+2]
                                );*/
                    }
                }
            }
            return LuaValue.valueOf(true);
        }
        
    }
}
