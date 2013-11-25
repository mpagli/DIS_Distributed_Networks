<map version="0.8.0">
<!-- To view this file, download free mind mapping software FreeMind from http://freemind.sourceforge.net -->
<node CREATED="1385129149617" ID="Freemind_Link_1134352329" MODIFIED="1385131276973" TEXT="DIS Project">
<node CREATED="1385130869745" ID="Freemind_Link_1740342078" MODIFIED="1385131272219" POSITION="right" TEXT="Problem description">
<node CREATED="1385130882347" ID="Freemind_Link_2898691" MODIFIED="1385131189097" TEXT="Aim: localizing sensor nodes without GPS nor external references"/>
<node CREATED="1385131208808" ID="Freemind_Link_994908734" MODIFIED="1385131219878" TEXT="Data: noisy distances between neighbor nodes"/>
<node CREATED="1385130950573" ID="Freemind_Link_222769564" MODIFIED="1385130971828" TEXT="Complexity: NP-Hard"/>
<node CREATED="1385130972373" ID="Freemind_Link_1205469706" MODIFIED="1385131393800" TEXT="Constraints">
<node CREATED="1385131002008" ID="Freemind_Link_30204606" MODIFIED="1385131397780" TEXT="Energy">
<node CREATED="1385130984464" ID="Freemind_Link_912494279" MODIFIED="1385131001524" TEXT="Low CPU power"/>
<node CREATED="1385131014238" ID="Freemind_Link_1358863021" MODIFIED="1385131101239" TEXT="Restrain communication =&gt; local view"/>
</node>
<node CREATED="1385131054679" ID="Freemind_Link_942749168" MODIFIED="1385131059269" TEXT="Noise on measurements"/>
</node>
</node>
<node CREATED="1385129156267" ID="_" MODIFIED="1385131614063" POSITION="right" TEXT="What do we want to do?">
<node CREATED="1385129215451" ID="Freemind_Link_1601436948" MODIFIED="1385131628427" TEXT="Implement &quot;Robust Distributed Network Localization...&quot; (base version, without phase 2)"/>
<node CREATED="1385131423485" ID="Freemind_Link_219433123" MODIFIED="1385131428953" TEXT="Should work because">
<node CREATED="1385131429446" ID="Freemind_Link_763426392" MODIFIED="1385131436759" TEXT="Only require informations from neighbors"/>
<node CREATED="1385131437725" ID="Freemind_Link_1502489245" MODIFIED="1385131593865" TEXT="Should be resistant to noise (uses robust quadrilaterals)">
<edge WIDTH="thin"/>
</node>
<node CREATED="1385131692709" ID="Freemind_Link_134203282" MODIFIED="1385131887295" TEXT="Algorithm idea is relatively simple, and has a polynomial complexity, so it should be possible to implement on real devices"/>
</node>
<node CREATED="1385129793013" ID="Freemind_Link_202575221" MODIFIED="1385131641813" TEXT="Experiment with different set of parameters"/>
<node CREATED="1385129799283" ID="Freemind_Link_1771983891" MODIFIED="1385131917576" TEXT="Try to implement an optimization (e.g. spring relaxation)"/>
</node>
<node CREATED="1385129206406" ID="Freemind_Link_1371317210" MODIFIED="1385131925655" POSITION="right" TEXT="Work distribution">
<node CREATED="1385130247503" ID="Freemind_Link_1141336236" MODIFIED="1385130292516" TEXT="1) Code sprint all team members together for base implementation"/>
<node CREATED="1385130279468" ID="Freemind_Link_1999259204" MODIFIED="1385131959448" TEXT="2) Divide in 3">
<node CREATED="1385130800415" ID="Freemind_Link_1454484150" MODIFIED="1385130809719" TEXT="1) Spring relaxation"/>
<node CREATED="1385130810174" ID="Freemind_Link_1431724034" MODIFIED="1385130833421" TEXT="2) Writing explicit test cases (bad cases)"/>
<node CREATED="1385130834061" ID="Freemind_Link_442216423" MODIFIED="1385130842752" TEXT="3) Exploring parameter space"/>
</node>
</node>
</node>
</map>
