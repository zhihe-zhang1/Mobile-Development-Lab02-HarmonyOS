// 实验02：声明式布局、弹性布局和屏幕适配
// 数值尺寸默认使用 vp；字体大小由系统按 fp 处理。

interface CourseData {
  id: string;
  title: string;
  subtitle: string;
  progress: number;
  symbol: string;
  color: string;
}

interface ShortcutData {
  id: string;
  title: string;
  description: string;
  symbol: string;
  color: string;
}

const COURSE_LIST: CourseData[] = [
  {
    id: 'arkui',
    title: 'ArkUI 声明式布局',
    subtitle: '第 3 章 · Flex 与响应式设计',
    progress: 70,
    symbol: 'UI',
    color: '#3666E8'
  },
  {
    id: 'arkts',
    title: 'ArkTS 编程基础',
    subtitle: '第 5 章 · 状态管理与组件',
    progress: 45,
    symbol: 'TS',
    color: '#8A5CF6'
  },
  {
    id: 'git',
    title: 'Git 版本控制',
    subtitle: '第 2 章 · 提交与协作',
    progress: 85,
    symbol: 'Git',
    color: '#15A897'
  }
];

const SHORTCUT_LIST: ShortcutData[] = [
  { id: 'schedule', title: '我的课表', description: '今日安排', symbol: '课', color: '#E9F0FF' },
  { id: 'tasks', title: '学习任务', description: '待办事项', symbol: '任', color: '#F1EAFF' },
  { id: 'files', title: '学习资料', description: '课程文档', symbol: '资', color: '#E4F6F3' },
  { id: 'notes', title: '我的笔记', description: '知识整理', symbol: '记', color: '#FFF0E2' }
];

// 独立组件：相同的概览卡片共享结构，减少重复的布局代码。
@Component
struct MetricCard {
  title: string = '';
  value: string = '';
  unit: string = '';
  hint: string = '';

  build() {
    Column({ space: 6 }) {
      Text(this.title)
        .fontSize(13)
        .fontColor('#7B879A')

      Row({ space: 4 }) {
        Text(this.value)
          .fontSize(28)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1F2A44')
        Text(this.unit)
          .fontSize(12)
          .fontColor('#7B879A')
      }
      .alignItems(VerticalAlign.Bottom)

      Text(this.hint)
        .fontSize(12)
        .fontColor('#64748B')
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
    .width('100%')
    .height(114)
    .padding(16)
    .alignItems(HorizontalAlign.Start)
    .backgroundColor('#FFFFFF')
    .borderRadius(18)
  }
}

// 独立组件：供响应式栅格重复使用。
@Component
struct ShortcutCard {
  title: string = '';
  description: string = '';
  symbol: string = '';
  color: string = '#E9F0FF';

  build() {
    Row({ space: 10 }) {
      Row() {
        Text(this.symbol)
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#3159B9')
      }
      .width(42)
      .height(42)
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)
      .backgroundColor(this.color)
      .borderRadius(12)

      Column({ space: 4 }) {
        Text(this.title)
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .fontColor('#25334C')
          .maxLines(1)

        Text(this.description)
          .fontSize(11)
          .fontColor('#8490A2')
          .maxLines(1)
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
    }
    .width('100%')
    .height(82)
    .padding(12)
    .alignItems(VerticalAlign.Center)
    .backgroundColor('#FFFFFF')
    .borderRadius(16)
  }
}

// 独立组件：课程行与进度条。
@Component
struct CourseCard {
  title: string = '';
  subtitle: string = '';
  progress: number = 0;
  symbol: string = '';
  color: string = '#3666E8';

  build() {
    Row({ space: 12 }) {
      Column() {
        Text(this.symbol)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#FFFFFF')
      }
      .width(50)
      .height(50)
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .backgroundColor(this.color)
      .borderRadius(14)

      Column({ space: 8 }) {
        Row({ space: 8 }) {
          Text(this.title)
            .fontSize(15)
            .fontWeight(FontWeight.Medium)
            .fontColor('#25334C')
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .layoutWeight(1)

          Text(`${this.progress}%`)
            .fontSize(12)
            .fontColor(this.color)
        }
        .width('100%')
        .alignItems(VerticalAlign.Center)

        Text(this.subtitle)
          .fontSize(12)
          .fontColor('#8792A3')
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })

        // 百分比宽度：进度条跟随父容器的可用宽度变化。
        Row() {
          Row()
            .width(`${this.progress}%`)
            .height(6)
            .backgroundColor(this.color)
            .borderRadius(3)
        }
        .width('100%')
        .height(6)
        .backgroundColor('#E9EDF5')
        .borderRadius(3)
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .padding(14)
    .alignItems(VerticalAlign.Center)
    .backgroundColor('#FFFFFF')
    .borderRadius(16)
  }
}

@Entry
@Component
struct Index {
  @State isCheckedIn: boolean = false;

  build() {
    Column() {
      // Scroll 负责小屏设备的纵向滚动，避免写死页面总高度。
      Scroll() {
        Column({ space: 18 }) {
          this.headerSection()
          this.bannerSection()
          this.overviewSection()
          this.shortcutSection()
          this.courseSection()
        }
        .width('100%')
        .alignItems(HorizontalAlign.Start)
        .padding({ left: 20, right: 20, top: 18, bottom: 24 })
      }
      .width('100%')
      .layoutWeight(1)
      .scrollBar(BarState.Off)

      this.bottomBar()
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F7FC')
  }

  @Builder
  headerSection() {
    // Row 的主轴为水平方向，交叉轴为垂直方向。
    Row({ space: 12 }) {
      Column({ space: 5 }) {
        Text('学习中心')
          .fontSize(25)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1F2A44')
        Text('保持专注，每天进步一点点')
          .fontSize(13)
          .fontColor('#8290A3')
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1) // 占据剩余空间，将头像推到最右侧。

      Image($r('app.media.student_avatar'))
        .width('48vp')
        .height('48vp')
        .objectFit(ImageFit.Cover)
        .borderRadius(24)
    }
    .width('100%')
    .alignItems(VerticalAlign.Center)
  }

  @Builder
  bannerSection() {
    Row({ space: 4 }) {
      Column({ space: 10 }) {
        Text('今日继续向前')
          .fontSize(21)
          .fontWeight(FontWeight.Bold)
          .fontColor('#FFFFFF')
          .maxLines(2)

        Text('完成一个小目标，积累大进步')
          .fontSize(12)
          .fontColor('#D9E5FF')
          .maxLines(2)

        Button(this.isCheckedIn ? '今日已签到' : '签到打卡')
          .height(34)
          .padding({ left: 14, right: 14 })
          .fontSize(13)
          .fontColor('#2959CE')
          .backgroundColor('#FFFFFF')
          .borderRadius(17)
          .enabled(!this.isCheckedIn)
          .onClick(() => {
            this.isCheckedIn = true;
          })
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1) // 文本区域弹性填充，插画保留固定 vp 尺寸。

      Image($r('app.media.study_banner'))
        .width('110vp')
        .height('118vp')
        .objectFit(ImageFit.Contain)
    }
    .width('100%')
    .height('168vp')
    .padding({ left: 20, right: 12, top: 16, bottom: 16 })
    .alignItems(VerticalAlign.Center)
    .backgroundColor('#2F63E7')
    .borderRadius(20)
  }

  @Builder
  overviewSection() {
    Column({ space: 12 }) {
      Text('学习概览')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1F2A44')

      // layoutWeight(1) 让两张卡平分父 Row 的剩余水平空间。
      Row({ space: 12 }) {
        MetricCard({
          title: '本周学习', value: '12.5', unit: '小时', hint: '较上周 +2.5 小时'
        })
          .layoutWeight(1)

        MetricCard({
          title: '已完成任务', value: '8', unit: '/ 10', hint: '继续保持好状态'
        })
          .layoutWeight(1)
      }
      .width('100%')
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  shortcutSection() {
    Column({ space: 12 }) {
      Text('快捷入口')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1F2A44')

      // GridRow 断点基于 vp：窄屏 1 列、手机 2 列、宽屏 4 列。
      GridRow({
        columns: 12,
        gutter: { x: 12, y: 12 },
        breakpoints: {
          value: ['320vp', '600vp', '840vp'],
          reference: BreakpointsReference.WindowSize
        }
      }) {
        ForEach(SHORTCUT_LIST, (item: ShortcutData) => {
          GridCol({ span: { xs: 12, sm: 6, md: 3, lg: 3 } }) {
            ShortcutCard({
              title: item.title,
              description: item.description,
              symbol: item.symbol,
              color: item.color
            })
          }
        }, (item: ShortcutData) => item.id)
      }
      .width('100%')
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  courseSection() {
    Column({ space: 12 }) {
      Row() {
        Text('正在学习')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1F2A44')
          .layoutWeight(1)
        Text('3 门课程')
          .fontSize(12)
          .fontColor('#8792A3')
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)

      ForEach(COURSE_LIST, (course: CourseData) => {
        CourseCard({
          title: course.title,
          subtitle: course.subtitle,
          progress: course.progress,
          symbol: course.symbol,
          color: course.color
        })
      }, (course: CourseData) => course.id)
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  bottomBar() {
    // 底部导航为静态 UI 示意，本实验不实现页面跳转。
    Flex({
      direction: FlexDirection.Row,
      justifyContent: FlexAlign.SpaceAround,
      alignItems: ItemAlign.Center
    }) {
      Column({ space: 4 }) {
        Text('●').fontSize(16).fontColor('#3267E7')
        Text('首页').fontSize(11).fontColor('#3267E7')
      }.layoutWeight(1)
      .alignItems(HorizontalAlign.Center)

      Column({ space: 4 }) {
        Text('▦').fontSize(16).fontColor('#A0AABE')
        Text('课程').fontSize(11).fontColor('#8792A3')
      }.layoutWeight(1)
      .alignItems(HorizontalAlign.Center)

      Column({ space: 4 }) {
        Text('◉').fontSize(16).fontColor('#A0AABE')
        Text('我的').fontSize(11).fontColor('#8792A3')
      }.layoutWeight(1)
      .alignItems(HorizontalAlign.Center)
    }
    .width('100%')
    .height(62)
    .backgroundColor('#FFFFFF')
  }
}