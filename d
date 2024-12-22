using System.Net.WebSockets;
using System.Text;

namespace WinFormsApp1
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        public class Node
        {
            public char? Symbol { get; set; }
            public int Data { get; set; }
            public Node Lewo { get; set; }
            public Node Prawo { get; set; }
        }


        private Dictionary<char, int> czestosc(string tekst)
        {
            var czestosc = new Dictionary<char, int>();
            foreach (char c in tekst)
            {
                if (!czestosc.ContainsKey(c))
                    czestosc[c] = 0;
                czestosc[c]++;
            }
            return czestosc;
        }


        private Node budujdrzewo(Dictionary<char, int> czestosc)
        {
            var nodes = czestosc.Select(n => new Node { Symbol = n.Key, Data = n.Value}).ToList();

            while(nodes.Count > 1)
            {
                var lewo = nodes[0];
                var prawo = nodes[1];

                var rodzic = new Node
                {
                    Symbol = null,
                    Data = lewo.Data + prawo.Data,
                    Lewo = lewo,
                    Prawo = prawo
                };

                nodes.Remove(lewo);
                nodes.Remove(prawo);
                nodes.Add(rodzic);
            }
            return nodes[0];
        }

        private void generujkod(Node node, string kod, Dictionary<char, string> kody)
        {
            if (node == null)
                return;
            if (node.Symbol.HasValue)
            {
                kody[node.Symbol.Value] = kod;
            }

            generujkod(node.Lewo, kod + "0", kody);
            generujkod(node.Prawo, kod + "1", kody);
        }

        private string Encode(string tekst, Dictionary<char,string> kody)
        {
            var sb = new StringBuilder();
            foreach (char c in tekst)
            {
                if(kody.TryGetValue(c, out string kod))
                {
                    sb.Append(kod);
                }
                else
                {
                    MessageBox.Show($"Znak '{c}' nie ma");
                    return string.Empty;
                }
            }
            return sb.ToString();
        }

        private void wyswietlkod(Dictionary<char, string> kody)
        {
            listBox1.Items.Clear();
            foreach (var n in kody)
            {
                listBox1.Items.Add($"{n.Key}: {n.Value}");
            }
        }
        

        





        private void textBox1_TextChanged(object sender, EventArgs e)
        {

        }

        private void Form1_Load(object sender, EventArgs e)
        {

        }

        private void button1_Click(object sender, EventArgs e)
        {
            string tekst = textBox1.Text;
            var listaczestosci = czestosc(tekst);
            Node root = budujdrzewo(listaczestosci);
            var kody = new Dictionary<char, string>();
            generujkod(root, "", kody);
            string encodedtekst = Encode(tekst, kody);
            wyswietlkod(kody);
            

        }

        private void listBox1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
    }
}
