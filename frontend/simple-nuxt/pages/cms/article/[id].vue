<script lang="ts" setup>
import { getArticleDetail, getArticleList } from "@/api/cms/article";
import type { ArticleInfo } from "@/api/cms/model/articleModel";
import { addComment, getCommentList } from "@/api/cms/comment";
import type { CommentInfo } from "~/api/cms/model/commentModel";

const article = ref<ArticleInfo>();
const hotArticles = ref<ArticleInfo[]>([]);
const route = useRoute();
const comment = ref<string>();
const comments = ref<CommentInfo[]>([]);
const { t } = useI18n();
const page = ref<number>(1);
const pageSize = ref<number>(10);
const store = useMemberStore();
const total = ref<number>(0);

function getArticleData() {
  getArticleDetail(route.params.id as string).then((res) => {
    article.value = res.data;
  });
}

function getHotArticleListData() {
  getArticleList({
    page: 1,
    pageSize: 10,
    sort: "hot",
  }).then((res) => {
    hotArticles.value = res.data.data;
  });
}

function submitComment() {
  if (comment.value?.length === 0) {
    ElMessage({
      message: t("cms.commentNotEmpty"),
      type: "error",
    });
    return;
  }

  addComment({
    content: comment.value,
    articleId: route.params.id as string,
    nickname: store.nickname,
  }).then((data) => {
    if (data.code === 0) {
      ElMessage({
        message: t("common.success"),
        type: "success",
      });
      getCommentListData();
    } else {
      ElMessage({
        message: t("common.failed"),
        type: "error",
      });
    }
  });
}

function getCommentListData() {
  getCommentList({
    page: page.value,
    pageSize: pageSize.value,
    articleId: route.params.id as string,
  }).then((data) => {
    if (data.code === 0) {
      comments.value = data.data.data;
      total.value = data.data.total;
    }
  });
}

onMounted(() => {
  getArticleData();
  getHotArticleListData();
  getCommentListData();
});
</script>
<template>
  <NuxtLayout>
    <el-row>
      <el-col :span="16" :sm="24" :md="24" :lg="16">
        <el-row>
          <el-card class="box-card w-full">
            <template #header>
              <div class="card-header">
                <span>{{ article?.title }}</span>
              </div>
            </template>
            <div v-html="article?.content"></div>
            <template #footer>
              <el-text size="small">{{ article?.author }}</el-text>
            </template>
          </el-card>

          <el-card class="box-card w-full mt-2">
            <template #header>
              <div class="card-header">
                <span>{{ $t("cms.comments") }}</span>
              </div>
            </template>
            <el-card v-for="item in comments" :key="item.id" class="mt-2">
              <template #header>
                <div class="card-header relative">
                  <el-text class="mx-1">{{ item.nickname }}</el-text>
                  <el-text class="absolute top-1 right-0 mx-1" size="small">
                    {{ item.formatCreatedAt }}</el-text
                  >
                </div>
              </template>
              {{ item.content }}
            </el-card>

            <el-pagination
              v-model:current-page="page"
              class="mt-2"
              layout="prev, pager, next"
              :total="total"
              :page-size="pageSize"
              @current-change="getCommentListData()"
            />

            <template #footer>
              <el-row class="mb-4 relative"
                ><span>{{ $t("cms.addComments") }}</span>
                <el-button
                  type="primary"
                  class="absolute top-0 right-0"
                  @click="submitComment()"
                  >{{ $t("common.submit") }}</el-button
                >
              </el-row>
              <el-row>
                <el-input
                  v-model="comment"
                  type="textarea"
                  :row="2"
                  :placeholder="$t('cms.commentsPlaceholder')"
                ></el-input
              ></el-row>
            </template>
          </el-card>
        </el-row>
      </el-col>
      <el-col :span="7" :sm="0" :md="0" :lg="7" :offset="1">
        <el-row>
          <el-card class="w-full">
            <template #header>
              <div class="card-header">
                <el-text size="large" tag="b">{{
                  $t("cms.hotArticles")
                }}</el-text>
              </div>
            </template>
            <el-row v-for="item in hotArticles" :key="item.id"
              ><el-button
                link
                @click="
                  navigateTo('/cms/article/' + item.id, {
                    open: { target: '_blank' },
                  })
                "
                >{{ item.title }}</el-button
              ></el-row
            >
          </el-card>
        </el-row>
      </el-col>
    </el-row>
  </NuxtLayout>
</template>
