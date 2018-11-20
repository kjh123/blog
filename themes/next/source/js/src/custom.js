var browserHeight = document.documentElement.clientHeight || document.body.clientHeight;
var scrollTop = document.documentElement.scrollTop || document.body.scrollTop;


//此函数用于创建复制按钮
function createCopyBtns() {
    var $codeArea = $("figure table");
    //复制成功后将要干的事情
    function changeToSuccess(item) {
        $imgOK = $("#copyBtn").find("#imgSuccess");
        if ($imgOK.css("display") == "none") {
            $imgOK.css({
                opacity: 0,
                display: "block"
            });
            $imgOK.animate({
                opacity: 1
            }, 1000);
            setTimeout(function() {
                $imgOK.animate({
                    opacity: 0
                }, 2000);
            }, 2000);
            setTimeout(function() {
                $imgOK.css("display", "none");
            }, 4000);
        };
    };
    //创建 全局复制按钮，仅有一组。包含：复制按钮，复制成功响应按钮
    //值得注意的是：1.按钮默认隐藏，2.位置使用绝对位置 position: absolute; (position: fixed 也可以，需要修改代码)
    $(".post-body").before('<div id="copyBtn" style="opacity: 0; position: absolute;top:0px;display: none;line-height: 1; font-size:1.5em"><span id="imgCopy" ><i class="fa fa-paste fa-fw"></i></span><span id="imgSuccess" style="display: none;"><i class="fa fa-check-circle fa-fw" aria-hidden="true"></i></span></div>');
    //创建 复制 插件，绑定单机时间到 指定元素，支持JQuery
    var clipboard = new ClipboardJS('#copyBtn', {
        target: function() {
            //返回需要复制的元素内容
            return document.querySelector("[copyFlag]");
        },
        isSupported: function() {
            //支持复制内容
            return document.querySelector("[copyFlag]");
        }
    });
    //复制成功事件绑定
    clipboard.on('success',
        function(e) {
            //清除内容被选择状态
            e.clearSelection();
            changeToSuccess(e);
        });
    //复制失败绑定事件
    clipboard.on('error',
        function(e) {
            console.error('Action:', e.action);
            console.error('Trigger:', e.trigger);
        });
    //鼠标 在复制按钮上滑动和离开后渐变显示/隐藏效果
    $("#copyBtn").hover(
        function() {
            $(this).stop();
            $(this).css("opacity", 1);
        },
        function() {
            $(this).animate({
                opacity: 0
            }, 2000);
        }
    );
}
//---
function FigureHover(figure) {
    $("[copyFlag]").removeAttr("copyFlag");
    $(figure).find(".code").attr("copyFlag", 1);
    $copyBtn = $("#copyBtn");
    if ($copyBtn.length != 0) {
        $copyBtn.stop();
        $copyBtn.css("opacity", 0.8);
        $copyBtn.css("display", "block");

        function setCopyBtnpos(obj) {
            var targeRect = obj.getBoundingClientRect();
            var vtop = targeRect.top > 0 ? targeRect.top : 0;
            vtop = vtop < (targeRect.bottom - $copyBtn.height()) ? vtop : (targeRect.bottom - $copyBtn.height());
            $copyBtn.css("top", vtop + 6);
            $copyBtn.css("left", targeRect.left - $copyBtn.width() - 3);
        }

        setCopyBtnpos(figure);
        resizePos(figure, setCopyBtnpos);
    }
    var block = $(figure).attr("block");
    if (block != 1) {
        var codeArea = $(figure).find(".code")[0];
        var width_code = codeArea.clientWidth;
        var width_Scroll = codeArea.scrollWidth;
        var width_Margin = -parseInt($(figure).css("marginRight"));
        $codePinBtn = $(figure).find(".codePinBtn");

        var width_Hide = width_Scroll - (width_code - width_Margin);
        if (width_Hide > 0) {
            $(figure).stop();

            $codePinBtn.stop();
            var width_Main = $("#main").width();
            var width_Base = $(".main-inner").width();
            var width_Blank = (width_Main - width_Base) / 2 - 10;

            if (width_Blank > 0) {
                if (width_Hide < width_Blank) {
                    width_Margin = width_Hide; //空白区域足够直接显示 全部
                } else {
                    width_Margin = width_Blank * 0.8;
                }
                $(figure).animate({marginRight: -width_Margin});
                $codePinBtn.animate({opacity: 1});
            }
        }
        ;
    }
    ;
};

function FigureHoverOut(figure) {
    $("#copyBtn").animate({
        opacity: 0
    }, 2000);
    var block = $(figure).attr("block");
    if (block != 1) {
        $(figure).stop();
        $(figure).animate({marginRight: "0"});
        var $codePinBtn = $(figure).find(".codePinBtn");
        $codePinBtn.stop();
        $codePinBtn.css({opacity: 0});
    }
};

$(window).resize(function () {
    var block;

    var width_Main = $("#main").width();
    var width_Base = $(".main-inner").width();
    var width_Blank = (width_Main - width_Base) / 2 - 10;
    $copyBtn = $("#copyBtn");
    if (width_Blank < $copyBtn.width()) {
        $copyBtn.css("display", "none");
    } else {
        $copyBtn.css("display", "block");
    }

    $("figure[block='1']").each(function () {
        block = $(this).attr("block");
        if (block == 1) {
            var width_This = $(this).width();
            var width_Scroll = $(this)[0].scrollWidth;
            var width_Margin = -parseInt($(this).css("marginRight"));

            var width_Hide = width_Scroll - (width_This - width_Margin);
            if (width_Hide > 0) {
                //var width_Main  = $("#main").width();
                //var width_Base  = $(".main-inner").width();
                //width_Blank = (width_Main - width_Base) / 2 - 10;

                if (width_Blank > 0) {
                    if (width_Hide < width_Blank) {
                        width_Margin = width_Hide; //空白区域足够直接显示 全部
                    } else {
                        width_Margin = width_Blank * 0.8;
                    }
                    $(this).css({
                        marginRight: -width_Margin
                    });
                    $(this).find(".codePinBtn").animate({
                        opacity: 1,
                        left: $(".post-body")[0].getBoundingClientRect().right + width_Margin - $(this).find(".codePinBtn").width()
                    });
                }
            }
        }
    });
});


$(document)
    .on('sidebar.isShowing', function () {
        if (NexT.utils.isDesktop) {
            //桌面状态下添加背景侧边栏
            $sidebar_background = $(".sidebar-background");
            if ($sidebar_background.length == 0) {
                $(".sidebar-inner").before('<div class="sidebar-background"></div>');
            }
            $(".sidebar-inner").css("display", "block");
            //是否显示 侧边栏 由缓存控制：显示后设置缓存标志 1
            localStorage.sidebar_show = 1;
        }
    })
    .on('sidebar.isHiding', function () {
        if (NexT.utils.isDesktop) {
            //是否显示 侧边栏 由缓存控制：隐藏后设置缓存标志 0
            localStorage.sidebar_show = 0;
            $(".sidebar-inner").css("display", "none");
        }
    });

$(document).ready(function () {

    createCopyBtns();

    //缓存控制是否显示 侧边栏 1：显示；0：隐藏；默认显示
    if (localStorage.sidebar_show) {
        if (Number(localStorage.sidebar_show) == 1) {
            NexT.utils.displaySidebar();
        } else {
            localStorage.sidebar_show = 0;
        }
    } else {
        NexT.utils.displaySidebar();
    }

    $(".header-inner").animate({padding: "25px 0 25px"}, 1000);

});

//感应鼠标是否在代码区
$("figure").hover(
    function() {
        //-------鼠标活动在代码块内
        //移除之前含有复制标志代码块的 copyFlag
        $("[copyFlag]").removeAttr("copyFlag");
        //在新的（当前鼠标所在代码区）代码块插入标志：copyFlag
        $(this).find(".code").attr("copyFlag", 1);
        //获取复制按钮
        $copyBtn = $("#copyBtn");

        if ($copyBtn.lenght != 0) {
            //获取到按钮的前提下进行一下操作
            //停止按钮动画效果
            //设置为 显示状态
            //修改 复制按钮 位置到 当前代码块开始部位
            //设置代码块 左侧位置
            $copyBtn.stop();
            $copyBtn.css("opacity", 0.8);
            $copyBtn.css("display", "block");
            // console.log($copyBtn.offset().top);
            $copyBtn.css("top", parseInt($copyBtn.css("top")) + $(this).offset().top - $copyBtn.offset().top + 3);
            $copyBtn.css("left", -$copyBtn.width() - 3);
        }
    },
    function() {
        //-------鼠标离开代码块
        //设置复制按钮可见度 2秒内到 0
        $("#copyBtn").animate({
            opacity: 0
        }, 2000);
    },
    function () {
        FigureHover(this);
        var block = $(this).attr("block");
        if (block == 1) {
            BindScrollTo($(this).find(".code")[0]);
        }
    },
    function () {
        FigureHoverOut(this);
        UnBindScroll();
    }
);

//----

$(".sidebar, .sidebar-toggle").hover(
    function () {
        $('#sidebarClock').css("opacity", "1");
        $('canvas#sidebar-author').stop();
        $('canvas#sidebar-author').animate({opacity: 1}, 1000);
        $('.sidebar-background').css("opacity", "0.15");
        $(".sidebar, .sidebar-toggle").css("opacity", "1");
    },
    function () {
        $('#sidebarClock').css("opacity", "0");
        $('canvas#sidebar-author').stop();
        $('canvas#sidebar-author').animate({opacity: 0}, 1000);
        $('.sidebar-background').css("opacity", "0");
        $(".sidebar, .sidebar-toggle").css("opacity", "0.98");
    }
);