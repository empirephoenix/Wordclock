package de.c3ma.ollo.mockup.ui;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Font;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;

import javax.swing.BorderFactory;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;

/**
 * created at 02.01.2018 - 12:57:02<br />
 * creator: ollo<br />
 * project: WS2812Emulation<br />
 * $Id: $<br />
 * @author ollo<br />
 */
public class WS2812Layout extends JFrame {
    
    /**
     * 
     */
    private static final long serialVersionUID = -6815557232118826140L;
    
    private ArrayList<String> mLines = new ArrayList<String>();
    private int mColumn = 0;
    private int mRow = 0;
    private Element[][] mElements;

    public static WS2812Layout parse(File file) {
        WS2812Layout layout = null;
        try {
            BufferedReader br = new BufferedReader(new FileReader(file));
            try {
                String line = br.readLine();
                if (line != null) {
                    layout = new WS2812Layout();
                }
                
                while (line != null) {
                    if (!line.startsWith("#")) {
                        layout.mLines.add(line);
                        layout.mRow++;
                        layout.mColumn = Math.max(layout.mColumn, line.length());
                    }
                    /* get the next line */
                    line = br.readLine();
                }
                
                /* parse each line */
                layout.parse();
                layout.createAndDisplayGUI();
            } finally {
                if (br != null) {
                    br.close();
                }
            }
        } catch (IOException ioe) {
            
        }
        return layout;
    }

    private void createAndDisplayGUI() {
        setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);

        JPanel contentPane = new JPanel();
        contentPane.setLayout(new BorderLayout());
        contentPane.setBorder(BorderFactory.createLineBorder(Color.DARK_GRAY, 2));

        JPanel ledPanel = new JPanel();
        ledPanel.setLayout(new GridLayout(this.mRow, this.mColumn, 10, 10));
        for (int i = 0; i < this.mRow; i++)
        {
            for (int j = 0; j < this.mColumn; j++)
            {
                if (this.mElements[i][j] != null) {
                    ledPanel.add(this.mElements[i][j]);
                }
            }
        }
        contentPane.add(ledPanel, BorderLayout.CENTER);
        JButton button = new JButton("Do something");
        button.setActionCommand("Do something");
        button.addActionListener(new ActionListener()
        {
            public void actionPerformed(ActionEvent ae)
            {
                JButton but = (JButton) ae.getSource();
                //FIXME some clever logic                           
            }
        });
        contentPane.add(button, BorderLayout.SOUTH);
        
        
        setContentPane(contentPane);
        pack();
        setLocationByPlatform(true);
        setVisible(true);
    }

    private void parse() {
        this.mElements = new Element[this.mRow][this.mColumn];
        int row=0;
        for (String line : this.mLines) {
            for (int i = 0; i < line.length(); i++) {
                char c = line.charAt(i);
                if ((('A' <= c) && (c <= 'Z')) ||
                    (('0' <= c) && (c <= '9')) ||
                    (c == 'Ä') || (c == 'Ö') || (c == 'Ü')) {
                    this.mElements[row][i] = new Element(c);
                } else {
                    this.mElements[row][i] = new Element();
                }
                this.mElements[row][i].setColor(0, 0, 0);
            }
            row++;
        }
    }
    
    public class Element extends JLabel {
        
        /**
         * 
         */
        private static final long serialVersionUID = -3933903441113933637L;
        
        private boolean noText=false;

        /**
         * Draw a simple rect
         */
        public Element() {
            super();
            this.noText = true;
            this.setBackground(Color.BLACK);
        }
        
        /**
         * Draw a character
         * @param character to show
         */
        public Element(char character) {
            super(""+character);
            setFont(new Font("Dialog", Font.BOLD, 24));
            setHorizontalAlignment(CENTER);
            //FIXME: Background color is not updated:
            this.setBackground(Color.BLACK);
        }
        
        public void setColor(int red, int green, int blue) {
            this.setForeground(new Color(red, green, blue));
            //FIXME changing the color is not working
            this.repaint();
            System.out.println( this.toString());
        }
        
        @Override
        public String toString() {
            StringBuilder sb = new StringBuilder();
            if (noText) {
                sb.append(" ");
            } else {
                sb.append("" + this.getText());
            }
            sb.append("|" + Integer.toHexString(this.getForeground().getRed()) + 
                    " " + Integer.toHexString(this.getForeground().getGreen()) +
                    " " + Integer.toHexString(this.getForeground().getBlue()));
            
            return sb.toString();
        }
    }

    public void updateLED(int index, byte red, byte green, byte blue) {
        if (this.mElements != null) {
            int i = (index / this.mColumn);
            int j = (index % this.mColumn);
            if ((i < this.mElements.length) &&
                    (j < this.mElements[i].length) &&
                    (this.mElements[i][j] != null)) {
                this.mElements[i][j].setColor(red, green, blue);
            }
        }
    }
    
}