package others;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.logging.LogRecord;

/**
 * Default formatter for Jason output.
 */
public class MASConsoleLogFormatterv2 extends java.util.logging.Formatter {

    public String format(LogRecord l) {
        StringBuilder s = new StringBuilder("[");
        s.append(getAgName(l));
        s.append("] ");
        s.append(l.getMessage());
        if (l.getThrown() != null) {
            StringWriter sw = new StringWriter();
            PrintWriter pw = new PrintWriter(sw);
            l.getThrown().printStackTrace(pw);
            s.append('\n');
            s.append(sw);
        }
        s.append('\n');
		
        // melhorar esse método para encontrar um ")" ou "]" para fazer a quebra de linha
        StringBuilder n = new StringBuilder(s.toString().replaceAll("(.{90}),", "$1,\n      "));
        return n.toString();
    }

    public static String getAgName(LogRecord l) {
        String lname = l.getLoggerName();
        int posd = lname.lastIndexOf('.');
        if (posd > 0) {
            return lname.substring(posd+1);
        }
        return lname;
    }
}
