#!/usr/bin/perl
use utf8;
use strict;
use warnings;
use Encode;

### やっぱりbinmode書かないと化ける
binmode STDIN, ":utf8";
binmode STDOUT, ":utf8";
binmode STDERR, ":utf8";

my $route = "";

my @worklist;

my %hash;
$hash{"CPUusr"} = [];
$hash{"procs"} = [];
$hash{"INTR"} = [];
$hash{"pswpins"} = [];
$hash{"pgpgins"} = [];
$hash{"tps"} = [];
$hash{"frmpgs"} = [];
$hash{"kbmemfree"} = [];
$hash{"kbswpfree"} = [];
$hash{"dentunusd"} = [];
$hash{"runqsz"} = [];
$hash{"ttyrcvins"} = [];
$hash{"devtps"} = [];
$hash{"ifacerxpcks"} = [];
$hash{"ifacerxerrs"} = [];
$hash{"calls"} = [];
$hash{"scalls"} = [];
$hash{"totsck"} = [];
$hash{"irecs"} = [];
$hash{"ihdrerrs"} = [];
$hash{"imsgs"} = [];
$hash{"ierrs"} = [];
$hash{"actives"} = [];
$hash{"atmptfs"} = [];
$hash{"idgms"} = [];
$hash{"tcp6sck"} = [];
$hash{"irec6s"} = [];
$hash{"ihdrer6s"} = [];
$hash{"imsg6s"} = [];
$hash{"ierr6s"} = [];
$hash{"idgm6s"} = [];
$hash{"cpu"} = [];

while (<>) {
    s/時/:/g;
    s/分/:/g;
    s/秒//g;
    s/平均値/Average/g;
    s/\d\d(\d\d)年(\d?\d)月(\d?\d)日/$2\/$3\/$1/;

    if (/^Linux/) {
        print;
	print "\n";
        next;
    }
    #CPU      %usr     %nice      %sys   %iowait    %steal      %irq     %soft    %guest     %idle
    elsif (/CPU\s+%usr/) {
        $route = "CPUusr";
        if (scalar(@{$hash{$route}}) == 0) {
            push(@{$hash{$route}}, $_);
        }
        next;
    }
    #proc/s   cswch/s
    elsif (/proc\/s\s+cswch\/s/) {
        $route = "procs";
        if (scalar(@{$hash{$route}}) == 0) {
            push(@{$hash{$route}}, $_);
        }
        next;
    }
    #INTR    intr/s
    elsif (/INTR\s+intr\/s/) {
        $route = "INTR";
        if (scalar(@{$hash{$route}}) == 0) {
            push(@{$hash{$route}}, $_);
        }
	next;
    }
    #pswpin/s pswpout/s
    elsif (/pswpin\/s\s+pswpout\/s/) {
        $route = "pswpins";
        if (scalar(@{$hash{$route}}) == 0) {
            push(@{$hash{$route}}, $_);
        }
	next;
    }
    #pgpgin/s pgpgout/s   fault/s  majflt/s  pgfree/s pgscank/s pgscand/s pgsteal/s    %vmeff
    elsif (/pgpgin\/s\s+pgpgout\/s/) {
        $route = "pgpgins";
        if (scalar(@{$hash{$route}}) == 0) {
            push(@{$hash{$route}}, $_);
        }
	next;
    }
    #tps      rtps      wtps   bread/s   bwrtn/s
    elsif (/tps\s+rtps/) {
        $route = "tps";
        if (scalar(@{$hash{$route}}) == 0) {
            push(@{$hash{$route}}, $_);
        }
	next;
    }
    #frmpg/s   bufpg/s   campg/s
    elsif (/frmpg\/s\s+bufpg\/s/) {
        $route = "frmpgs";
        if (scalar(@{$hash{$route}}) == 0) {
            push(@{$hash{$route}}, $_);
        }
	next;
    }
    #kbmemfree kbmemused  %memused kbbuffers  kbcached  kbcommit   %commit
    elsif (/kbmemfree\s+kbmemused/) {
        $route = "kbmemfree";
        if (scalar(@{$hash{$route}}) == 0) {
            push(@{$hash{$route}}, $_);
        }
	next;
    }
    #kbswpfree kbswpused  %swpused  kbswpcad   %swpcad
    elsif (/kbswpfree\s+kbswpused/) {
        $route = "kbswpfree";
        if (scalar(@{$hash{$route}}) == 0) {
            push(@{$hash{$route}}, $_);
        }
	next;
    }
    #dentunusd   file-nr  inode-nr    pty-nr
    elsif (/dentunusd/) {
        $route = "dentunusd";
        if (scalar(@{$hash{$route}}) == 0) {
            push(@{$hash{$route}}, $_);
        }
	next;
    }
    #runq-sz  plist-sz   ldavg-1   ldavg-5  ldavg-15
    elsif (/runq-sz\s+plist-sz/) {
        $route = "runqsz";
        if (scalar(@{$hash{$route}}) == 0) {
            push(@{$hash{$route}}, $_);
        }
	next;
    }
    #TTY   rcvin/s   xmtin/s framerr/s prtyerr/s     brk/s   ovrun/s
    elsif (/TTY\s+rcvin\/s/) {
        $route = "ttyrcvins";
        if (scalar(@{$hash{$route}}) == 0) {
            push(@{$hash{$route}}, $_);
        }
	next;
    }
    #DEV       tps  rd_sec/s  wr_sec/s  avgrq-sz  avgqu-sz     await     svctm     %util
    elsif (/DEV\s+tps/) {
        $route = "devtps";
        if (scalar(@{$hash{$route}}) == 0) {
            push(@{$hash{$route}}, $_);
        }
	next;
    }
    #IFACE   rxpck/s   txpck/s    rxkB/s    txkB/s   rxcmp/s   txcmp/s  rxmcst/s
    elsif (/IFACE\s+rxpck\/s\s+txpck\/s/) {
        $route = "ifacerxpcks";
        if (scalar(@{$hash{$route}}) == 0) {
            push(@{$hash{$route}}, $_);
        }
	next;
    }
    #IFACE   rxerr/s   txerr/s    coll/s  rxdrop/s  txdrop/s  txcarr/s  rxfram/s  rxfifo/s  txfifo/s
    elsif (/IFACE\s+rxerr\/s/) {
        $route = "ifacerxerrs";
        if (scalar(@{$hash{$route}}) == 0) {
            push(@{$hash{$route}}, $_);
        }
	next;
    }
    #call/s retrans/s    read/s   write/s  access/s  getatt/s
    elsif (/call\/s\s+retrans\/s/) {
        $route = "calls";
        if (scalar(@{$hash{$route}}) == 0) {
            push(@{$hash{$route}}, $_);
        }
	next;
    }
    #scall/s badcall/s  packet/s     udp/s     tcp/s     hit/s    miss/s   sread/s  swrite/s saccess/s sgetatt/s
    elsif (/scall\/s\s+badcall\/s/) {
        $route = "scalls";
        if (scalar(@{$hash{$route}}) == 0) {
            push(@{$hash{$route}}, $_);
        }
	next;
    }
    #totsck    tcpsck    udpsck    rawsck   ip-frag    tcp-tw
    elsif (/totsck\s+tcpsck/) {
        $route = "totsck";
        if (scalar(@{$hash{$route}}) == 0) {
            push(@{$hash{$route}}, $_);
        }
	next;
    }
    #irec/s  fwddgm/s    idel/s     orq/s   asmrq/s   asmok/s  fragok/s fragcrt/s
    elsif (/irec\/s/) {
        $route = "irecs";
        if (scalar(@{$hash{$route}}) == 0) {
            push(@{$hash{$route}}, $_);
        }
	next;
    }
    #ihdrerr/s iadrerr/s iukwnpr/s   idisc/s   odisc/s   onort/s    asmf/s   fragf/s
    elsif (/ihdrerr\/s\s+iadrerr\/s/) {
        $route = "ihdrerrs";
        if (scalar(@{$hash{$route}}) == 0) {
            push(@{$hash{$route}}, $_);
        }
	next;
    }
    #imsg/s    omsg/s    iech/s   iechr/s    oech/s   oechr/s     itm/s    itmr/s     otm/s    otmr/s  iadrmk/s iadrmkr/s  oadrmk/s oadrmkr/s
    elsif (/imsg\/s\s+omsg\/s/) {
        $route = "imsgs";
        if (scalar(@{$hash{$route}}) == 0) {
            push(@{$hash{$route}}, $_);
        }
	next;
    }
    #ierr/s    oerr/s idstunr/s odstunr/s   itmex/s   otmex/s iparmpb/s oparmpb/s   isrcq/s   osrcq/s  iredir/s  oredir/s
    elsif (/ierr\/s\s+oerr\/s/) {
        $route = "ierrs";
        if (scalar(@{$hash{$route}}) == 0) {
            push(@{$hash{$route}}, $_);
        }
	next;
    }
    #active/s passive/s    iseg/s    oseg/s
    elsif (/active\/s\s+passive\/s/) {
        $route = "actives";
        if (scalar(@{$hash{$route}}) == 0) {
            push(@{$hash{$route}}, $_);
        }
	next;
    }
    #atmptf/s  estres/s retrans/s isegerr/s   orsts/s
    elsif (/atmptf\/s\s+estres\/s/) {
        $route = "atmptfs";
        if (scalar(@{$hash{$route}}) == 0) {
            push(@{$hash{$route}}, $_);
        }
	next;
    }
    #idgm/s    odgm/s  noport/s idgmerr/s
    elsif (/idgm\/s\s+odgm\/s/) {
        $route = "idgms";
        if (scalar(@{$hash{$route}}) == 0) {
            push(@{$hash{$route}}, $_);
        }
        next;
    }
    #tcp6sck   udp6sck   raw6sck  ip6-frag
    elsif (/tcp6sck\s+udp6sck/) {
        $route = "tcp6sck";
        if (scalar(@{$hash{$route}}) == 0) {
            push(@{$hash{$route}}, $_);
        }
	next;
    }
    #irec6/s fwddgm6/s   idel6/s    orq6/s  asmrq6/s  asmok6/s imcpck6/s omcpck6/s fragok6/s fragcr6/s
    elsif (/irec6\/sfwddgm6\/s/) {
        $route = "irec6s";
        if (scalar(@{$hash{$route}}) == 0) {
            push(@{$hash{$route}}, $_);
        } 
        next;
    }
    #ihdrer6/s iadrer6/s iukwnp6/s  i2big6/s  idisc6/s  odisc6/s  inort6/s  onort6/s   asmf6/s  fragf6/s itrpck6/s
    elsif (/ihdrer6\/s/) {
        $route = "ihdrer6s";
        if (scalar(@{$hash{$route}}) == 0) {
            push(@{$hash{$route}}, $_);
        } 
        next;
    }
    #imsg6/s   omsg6/s   iech6/s  iechr6/s  oechr6/s  igmbq6/s  igmbr6/s  ogmbr6/s igmbrd6/s ogmbrd6/s irtsol6/s ortsol6/s  irtad6/s inbsol6/s onbsol6/s  inbad6/s  onbad6/s
    elsif (/imsg6\/s\s+omsg6\/s/) {
        $route = "imsg6s";
        if (scalar(@{$hash{$route}}) == 0) {
            push(@{$hash{$route}}, $_);
        }  
	next;
    }
    #ierr6/s idtunr6/s odtunr6/s  itmex6/s  otmex6/s iprmpb6/s oprmpb6/s iredir6/s oredir6/s ipck2b6/s opck2b6/s
    elsif (/ierr6\/s\s+idtunr6\/s/) {
        $route = "ierr6s";
        if (scalar(@{$hash{$route}}) == 0) {
            push(@{$hash{$route}}, $_);
        }
        next;
    }
    #idgm6/s   odgm6/s noport6/s idgmer6/s
    elsif (/idgm6\/s\s+odgm6\/s/) {
        $route = "idgm6s";
        if (scalar(@{$hash{$route}}) == 0) {
            push(@{$hash{$route}}, $_);
        }
	next;
    }
    #CPU       MHz
    elsif (/CPU\s+MHz/) {
        $route = "cpu";
        if (scalar(@{$hash{$route}}) == 0) {
            push(@{$hash{$route}}, $_);
        }
	next;
    }
    #空行
    elsif (/^\s*$/) {
        # ここまでに溜めた分を各分類にプッシュ
        push(@{$hash{$route}}, @worklist);
        @worklist = ();
        $route = "";
    }
    else {
        #die("想定外のタイトル行");
        push(@worklist, $_);
    }

    #print "$route\n";
}

print join("", @{$hash{"CPUusr"}}) . "\n";
print join("", @{$hash{"procs"}}) . "\n";
print join("", @{$hash{"INTR"}}) . "\n";
print join("", @{$hash{"pswpins"}}) . "\n";
print join("", @{$hash{"pgpgins"}}) . "\n";
print join("", @{$hash{"tps"}}) . "\n";
print join("", @{$hash{"frmpgs"}}) . "\n";
print join("", @{$hash{"kbmemfree"}}) . "\n";
print join("", @{$hash{"kbswpfree"}}) . "\n";
print join("", @{$hash{"dentunusd"}}) . "\n";
print join("", @{$hash{"runqsz"}}) . "\n";
print join("", @{$hash{"ttyrcvins"}}) . "\n";
print join("", @{$hash{"devtps"}}) . "\n";
print join("", @{$hash{"ifacerxpcks"}}) . "\n";
print join("", @{$hash{"ifacerxerrs"}}) . "\n";
print join("", @{$hash{"calls"}}) . "\n";
print join("", @{$hash{"scalls"}}) . "\n";
print join("", @{$hash{"totsck"}}) . "\n";
print join("", @{$hash{"irecs"}}) . "\n";
print join("", @{$hash{"ihdrerrs"}}) . "\n";
print join("", @{$hash{"imsgs"}}) . "\n";
print join("", @{$hash{"ierrs"}}) . "\n";
print join("", @{$hash{"actives"}}) . "\n";
print join("", @{$hash{"atmptfs"}}) . "\n";
print join("", @{$hash{"idgms"}}) . "\n";
print join("", @{$hash{"tcp6sck"}}) . "\n";
print join("", @{$hash{"irec6s"}}) . "\n";
print join("", @{$hash{"ihdrer6s"}}) . "\n";
print join("", @{$hash{"imsg6s"}}) . "\n";
print join("", @{$hash{"ierr6s"}}) . "\n";
print join("", @{$hash{"idgm6s"}}) . "\n";
print join("", @{$hash{"cpu"}}) . "\n";

