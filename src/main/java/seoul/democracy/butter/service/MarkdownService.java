package seoul.democracy.butter.service;

import com.vladsch.flexmark.ext.toc.TocBlock;
import com.vladsch.flexmark.ext.toc.TocExtension;
import com.vladsch.flexmark.ext.tables.TablesExtension;
import com.vladsch.flexmark.ext.toc.internal.TocNodeRenderer;
import com.vladsch.flexmark.html.HtmlRenderer;
import com.vladsch.flexmark.html.HtmlRenderer.Builder;
import com.vladsch.flexmark.html.HtmlRenderer.HtmlRendererExtension;
import com.vladsch.flexmark.html.renderer.DelegatingNodeRendererFactory;
import com.vladsch.flexmark.html.renderer.NodeRenderer;
import com.vladsch.flexmark.html.renderer.NodeRendererContext;
import com.vladsch.flexmark.html.renderer.NodeRendererFactory;
import com.vladsch.flexmark.html.renderer.NodeRenderingHandler;
import com.vladsch.flexmark.parser.Parser;
import com.vladsch.flexmark.util.ast.Document;
import com.vladsch.flexmark.util.data.DataHolder;
import com.vladsch.flexmark.util.data.DataKey;
import com.vladsch.flexmark.util.data.MutableDataHolder;
import com.vladsch.flexmark.util.data.MutableDataSet;

import org.springframework.stereotype.Service;

import java.util.Arrays;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.WeakHashMap;

@Service
public class MarkdownService {
    private final DataHolder OPTIONS = new MutableDataSet().set(Parser.EXTENSIONS,
            Arrays.asList(TocExtension.create(), CustomExtension.create(), TablesExtension.create()));
    final Parser PARSER = Parser.builder(OPTIONS).build();
    final HtmlRenderer RENDERER = HtmlRenderer.builder(OPTIONS).indentSize(2).build();
    public static final DataKey<String> TOC_HTML = new DataKey<>("TOC_HTML", "");
    private static final Map<String, String> res = new WeakHashMap<String, String>();

    static class CustomNodeRenderer implements NodeRenderer {
        public static class Factory implements DelegatingNodeRendererFactory {

            @Override
            public NodeRenderer apply(DataHolder options) {
                return new CustomNodeRenderer();
            }

            @Override
            public Set<Class<? extends NodeRendererFactory>> getDelegates() {
                Set<Class<? extends NodeRendererFactory>> set = new HashSet<>();
                // add node renderer factory classes to which this renderer will delegate some
                // of its rendering
                // core node renderer is assumed to have all depend it so there is no need to
                // add it
                set.add(TocNodeRenderer.Factory.class);
                return set;

                // return null if renderer does not delegate or delegates only to core node
                // renderer
                // return null;
            }
        }

        @Override
        public Set<NodeRenderingHandler<?>> getNodeRenderingHandlers() {
            HashSet<NodeRenderingHandler<?>> set = new HashSet<>();
            set.add(new NodeRenderingHandler<>(TocBlock.class, (node, context, html) -> {
                // test the node to see if it needs overriding
                NodeRendererContext subContext = context.getDelegatedSubContext(true);
                subContext.delegateRender();
                String tocText = subContext.getHtmlWriter().toString(0);

                context.getDocument().set(TOC_HTML, tocText);
            }));

            return set;
        }
    }

    static class CustomExtension implements HtmlRendererExtension {
        @Override
        public void rendererOptions(MutableDataHolder options) {

        }

        @Override
        public void extend(Builder rendererBuilder, String rendererType) {
            rendererBuilder.nodeRendererFactory(new CustomNodeRenderer.Factory());
        }

        static CustomExtension create() {
            return new CustomExtension();
        }
    }

    public String getTOC(String md) {
        Document document = PARSER.parse("[TOC levels=1-3] \n" + md);
        RENDERER.render(document);
        String toc = TOC_HTML.getFrom(document);
        return toc;
    }

    public Map<String, String> parseHtml(String md) {
        Document document = PARSER.parse("[TOC levels=1-3] \n" + md);
        String html = RENDERER.render(document);
        String toc = TOC_HTML.getFrom(document);
        res.put("html", html);
        res.put("toc", toc);
        return res;
    }

    // use the PARSER to parse and RENDERER to render with pegdown compatibility
    public void main(String[] args) {
        // You can re-use parser and renderer instances
        Document document = PARSER.parse("" + "[TOC levels=1-3] \n" + "\n" + "# Heading **some bold** 1\n"
                + "## Heading 1.1 _some italic_\n" + "### Heading 1.1.1\n ## #HEL_P \n"
                + "### Heading 1.1.2 #뭐지0_HELP  **_some bold italic_**\n #하하" + "");
        String html = RENDERER.render(document);
        String toc = TOC_HTML.getFrom(document);
        String html2 = html.replaceAll("(#[_a-zA-Z0-9ㄱ-ㅎ가-힣]*)", "<b class='tag'>$1</b>");
        String toc2 = toc.replaceAll("([>\\s])(#[_a-zA-Z0-9ㄱ-ㅎ가-힣]*)", "$1<b class='tag'>$2</b>");
        // Pattern p1 = Pattern.compile("(#[a-zA-Z0-9ㄱ-ㅎ가-힣]*)");
        // Matcher matcher = p1.matcher(html);

        System.out.println(html2);
        System.out.println(toc2);
        // if(matcher.find()){
        // // System.out.print(matcher.group(0));
        // System.out.print(matcher.group());
        // }
        // System.out.println("<div class=\"toc\">");
        // System.out.print(toc);
        // System.out.println("</div>");

        // System.out.println("<div class=\"body\">");
        // System.out.print(html);
        // System.out.println("</div>");
    }
}
