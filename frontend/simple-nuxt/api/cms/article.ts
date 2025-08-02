import type { BaseDataResp, BaseListResp } from "../base/model/baseModel";
import type { ArticleInfo, GetArticleListReq } from "./model/articleModel";

export enum Api {
  GetArticleList = "/cms-api/article/list",
  GetArticleDetail = "/cms-api/article",
}

export const getArticleList = (params: GetArticleListReq) =>
  xFetch<BaseDataResp<BaseListResp<ArticleInfo>>>(Api.GetArticleList, {
    params,
  });

export const getArticleDetail = (id: string) =>
  xFetch<BaseDataResp<ArticleInfo>>(Api.GetArticleDetail + "/" + id);
